-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP VIEW id_N_W_rounds, id_W_L, id_L, id_W, id_wl;
DROP TABLE players, matches;

CREATE TABLE players (
	id SERIAL PRIMARY KEY,
	name TEXT
);

CREATE TABLE matches (
	winner SERIAL REFERENCES players(id),
	loser SERIAL REFERENCES players(id)
);

CREATE VIEW id_W AS SELECT players.id AS id, COUNT(matches.winner) AS wins
FROM players LEFT JOIN matches ON players.id = matches.winner GROUP BY players.id;

CREATE VIEW id_L AS SELECT players.id AS id, COUNT(matches.loser) AS loses
FROM players LEFT JOIN matches ON players.id = matches.loser GROUP BY players.id;

CREATE VIEW id_W_L AS SELECT id_W.id AS id, id_W.wins as wins, id_L.loses as loses
FROM id_W LEFT JOIN id_L ON id_W.id = id_L.id; 

CREATE VIEW id_N_W_rounds AS SELECT players.id AS id, 
	players.name AS name, 
	id_W_L.wins AS wins, 
	id_W_L.wins + id_W_L.loses AS rounds 
	FROM players LEFT JOIN id_W_L ON players.id = id_W_L.id ORDER BY id_W_L.wins DESC;
