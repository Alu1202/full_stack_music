const pool = require('../config/db.config');

const searchMusic = async (req, res) => {
    try {
        const {
            startYear,
            endYear,
            trackName,
            artistName,
            popularity,
            duration
        } = req.query;

        if (startYear && !(/^\d{4}$/.test(startYear))) {
            return res.status(400).json({
                success: false,
                error: 'Invalid startYear format. Use YYYY format.'
            });
        }

        if (endYear && !(/^\d{4}$/.test(endYear))) {
            return res.status(400).json({
                success: false,
                error: 'Invalid endYear format. Use YYYY format.'
            });
        }

        let query = `
            SELECT 
                track_id,
                track_name,
                artists,
                YEAR(release_date) as year,
                duration_ms as duration,
                popularity
            FROM music_data
        `;
        
        const params = [];
        let conditions = [];

        if (startYear && endYear) {
            conditions.push(`YEAR(release_date) BETWEEN ? AND ?`);
            params.push(startYear, endYear);
        }

        if (trackName) {
            conditions.push(`track_name LIKE ?`);
            params.push(`%${trackName}%`);
        }

        if (artistName) {
            conditions.push(`artists LIKE ?`);
            params.push(`%${artistName}%`);
        }

        if (popularity) {
            conditions.push(`popularity <= ?`);
            params.push(popularity);
        }

        if (duration) {
            conditions.push(`duration_ms <= ?`);
            params.push(duration);
        }

        if (conditions.length > 0) {
            query += ` WHERE ` + conditions.join(' AND ');
        }

        const [results] = await pool.query(query, params);

        const transformedResults = results.map(result => ({
            track_id: result.track_id,
            track_name: result.track_name,
            artists: result.artists,
            year: result.year,
            duration: formatDuration(result.duration),
            popularity: result.popularity
        }));

        res.json({
            success: true,
            data: transformedResults
        });

    } catch (error) {
        console.error('Search error:', error);
        res.status(500).json({
            success: false,
            error: 'Internal Server Error'
        });
    }
};

const getStatistics = async (req, res) => {
    try {
        const query = `
            SELECT 
                MAX(YEAR(release_date)) as maxYear,
                MIN(YEAR(release_date)) as minYear,
                MIN(popularity) as minPopularity,
                MAX(popularity) as maxPopularity
            FROM music_data
        `;

        const [results] = await pool.query(query);

        res.json({
            success: true,
            data: {
                maxYear: results[0].maxYear,
                minYear: results[0].minYear,
                minPopularity: results[0].minPopularity,
                maxPopularity: results[0].maxPopularity
            }
        });

    } catch (error) {
        console.error('Statistics error:', error);
        res.status(500).json({
            success: false,
            error: 'Internal server error'
        });
    }
};

const formatDuration = (ms) => {
    const minutes = Math.floor(ms / 60000);
    const seconds = ((ms % 60000) / 1000).toFixed(0);
    return `${minutes}:${seconds.padStart(2, '0')}`;
};

module.exports = {
    searchMusic,
    getStatistics
};
