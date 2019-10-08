CREATE DATABASE favorite_db;

CREATE TABLE favorite_foods(
	food VARCHAR(50),
    score INTEGER
    ); 

CREATE TABLE favorite_songs(
	song VARCHAR(100),
	artist VARCHAR(50),
	score INTEGER
);

CREATE TABLE favorite_movies(
	film VARCHAR(50) NOT NULL,
    five_times boolean,
    score INTEGER
    );
