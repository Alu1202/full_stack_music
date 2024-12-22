const express = require('express');
const router = express.Router();
const musicController = require('../controllers/music.controller');

router.get('/search', musicController.searchMusic);
router.get('/statistics', musicController.getStatistics);

module.exports = router;
