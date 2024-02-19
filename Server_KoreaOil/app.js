/*
    URL: touching-special-molly.ngrok-free.app
    NGROK: ngrok http --domain=touching-special-molly.ngrok-free.app 80
    Command: lsof -i tcp:80 kill -9 PID 28476
*/

const mysql = require("mysql2/promise");
const dbconfig = require("./config/database.js");

const axios = require('axios').default;
const express = require("express");
const app = express();
const port = 80;

const pool = mysql.createPool(dbconfig);

const areaRoutes = require("./routes/areaRoutes");

app.set('port', process.env.PORT || port);

app.use('/', areaRoutes);

app.get('/api/regions', async (req, res) => {
    const regionName = req.query.regionName;
    const prodcd = req.query.prodcd;
    const query = 'SELECT * FROM Regions WHERE REGION_NAME = ?';

    try {
        // 연결 풀에서 연결을 가져와 쿼리를 실행
        const [rows] = await pool.query(query, [regionName]);

        if (rows.length > 0) {
            var regionCode = rows[0].REGION_CODE;
            const apiUrl = `http://www.opinet.co.kr/api/oilPriceList.do?code=C231214009&out=json&area=${regionCode}`;

            const response = await axios.get(apiUrl);
            const filteredOilPrices = response.data.RESULT.OIL
                .filter(oilData => oilData.PRODCD === prodcd)
                .sort((a, b) => a.PRICE - b.PRICE)
                .slice(0, 10)
                .map(oilData => ({
                    stationId: oilData.UNI_ID,
                    prodcd: oilData.PRODCD,
                    price: oilData.PRICE,
                    date: oilData.TRADE_DT,
                    time: oilData.TRADE_TM
                }));

            const details = await Promise.all(filteredOilPrices.map(async oilPrice => {
                const stationDetailURL = `http://www.opinet.co.kr/api/detailById.do?code=C231214009&out=json&id=${oilPrice.stationId}`;
                const detailResponse = await axios.get(stationDetailURL);
                return detailResponse.data.RESULT;
            }));

            console.log(details);
            res.json({ details });
        } else {
            res.status(404).json({code: 404, message: 'Region not found'});
        }
    } catch (error) {
        console.error('Error occurred: ', error);
        res.status(500).json({code: 500, message: 'An error occurred'});
    }
});

app.listen(app.get('port'), () => {
    console.log(`Server is running on http://localhost:${app.get('port')}`);
});
