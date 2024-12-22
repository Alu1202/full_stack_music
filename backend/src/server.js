require('dotenv').config();
const express = require('express');
const cors = require('cors');
const musicRoutes = require('./routes/music.routes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api', musicRoutes);

app.use((err, req, res, ext) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
