const express = require('express');
const router = express.Router();

router.get('/area', (req, res) => {
    console.log(req.query.code);
    console.log(req.query.area);
    res.status(200).json({ name: "TEST입니다" });
});

module.exports = router;
