## Author
Alekh Agrawal  [https://www.linkedin.com/in/alekh-agrawal-2b1366191/]

# Music DB Backend

This project provides a RESTful API for  retrieving music data.

## Table of Contents
- [Music API](#music-api)
- [Technologies](#technologies)
- [Author](#author)
- [API Endpoints](#api-endpoints)
    - [GET /api/statistics](#get-apistatistics)
    - [GET /api/search](#get-apisearch)
- [Database Schema](#database-schema)
- [Data Source](#data-source)

## Technologies
This project uses the following technologies:
- Node.js
- Express
- MySQL
- Docker
- Nodemon



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
# Music API

This project uses the following technologies:
- Node.js
- Express
- MySQL
- Docker

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