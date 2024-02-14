/*
    URL: touching-special-molly.ngrok-free.app
    NGROK: ngrok http --domain=touching-special-molly.ngrok-free.app 80
    Command: lsof -i tcp:80 kill -9 PID 28476
*/

const mysql = require("mysql");
const dbconfig = require("./config/database.js");
const connection = mysql.createConnection(dbconfig);

const axios = require('axios').default;

const express = require("express");
const app = express();
const port = 80;

const areaRoutes = require("./routes/areaRoutes");

app.set('port', process.env.PORT || port);

app.use('/', areaRoutes);

app.get('/api/regions', (req, res) => {
  const regionName = req.query.regionName;
  const prodcd = req.query.prodcd;
  const query = 'SELECT * FROM Regions WHERE REGION_NAME = ?';

  connection.query(query, [regionName], (error, rows) => {
    if (error) {
      // 에러 처리
      console.error('Error occurred: ', error);
      res.status(500).json({code: 500, message: 'An error occurred'});
    } else {
      // 쿼리 결과 로깅 및 클라이언트에 응답 전송
      console.log('Query result: ', rows);

      if (rows.length > 0) {
        var regionCode = rows[0].REGION_CODE;
        const apiUrl = `http://www.opinet.co.kr/api/oilPriceList.do?code=C231214009&out=json&area=${regionCode}`;

        axios.get(apiUrl)
            .then(function (response) {
              const filteredOilPrices = response.data.RESULT.OIL
                  .filter(oilData => oilData.PRODCD === prodcd) // prodcd가 일치하는 항목만 필터링
                  .sort((a, b) => a.PRICE - b.PRICE)
                  .slice(0, 10) // 최대 10개 항목 선택
                  .map(oilData => ({
                    stationId: oilData.UNI_ID,
                    prodcd: oilData.PRODCD,
                    price: oilData.PRICE,
                    date: oilData.TRADE_DT,
                    time: oilData.TRADE_TM
                  }));

              // 상세 정보 요청을 위한 모든 프로미스를 생성
              const detailPromises = filteredOilPrices.map(oilPrice => {
                const stationDetailURL = `http://www.opinet.co.kr/api/detailById.do?code=C231214009&out=json&id=${oilPrice.stationId}`;
                return axios.get(stationDetailURL).then(response => response.data.RESULT); // API 응답의 데이터 반환
              });

              // 모든 프로미스가 완료되기를 기다림
              Promise.all(detailPromises)
                  .then(allDetails => {
                    // 모든 상세 정보가 담긴 배열로 응답
                    console.log(allDetails)
                    res.json({ details: allDetails });
                  })
                  .catch(error => {
                    console.error('Error fetching station details: ', error);
                    res.status(500).json({ message: 'Error fetching station details' });
                  });
            });
      } else {
        // 쿼리 결과가 없는 경우, 404 상태 코드와 메시지 전송
        res.status(404).json({code: 404, message: 'Region not found'});
      }
    }
  });
});

app.listen(app.get('port'), () => {
  console.log(`Server is running on http://localhost:${app.get('port')}`);
});
