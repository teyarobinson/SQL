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
    
CREATE TABLE programming_languages(
    id  int auto_increment NOT NULL ,
    languages VARCHAR(50),
    rating INTEGER,
    PRIMARY KEY (id)
    );
    

    
    
    
