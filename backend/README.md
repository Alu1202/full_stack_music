# Music API

This project uses the following technologies:
- Node.js
- Express
- MySQL
- Docker

## Author
Alekh Agrawal

## API Endpoints
- `GET /api/statistics` - Retrieve static filter options
- `GET /api/search` - Retrieve track details

### `GET /api/search`
This endpoint retrieves track details based on various query parameters.

#### Query Parameters:
- `startYear`: The starting year for the search (format: YYYY).
- `endYear`: The ending year for the search (format: YYYY).
- `trackName`: The name of the track (partial or full).
- `artistName`: The name of the artist (partial or full).
- `popularity`: The maximum popularity of the track.
- `duration`: The maximum duration of the track in milliseconds.

### `GET /api/statistics`
This endpoint retrieves static filter options such as the maximum and minimum year of release and popularity.

#### No Query Parameters:
This endpoint does not require any query parameters.

## Database Schema
The project includes a database schema to manage music data.

## Data Source
The music data is sourced from a CSV file downloaded from Kaggle.