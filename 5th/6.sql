COPY aircrafts_tmp FROM STDIN WITH ( FORMAT csv );

IL9, Ilyushin IL96, 9800
I93, Ilyushin IL96-300, 9800
\.


SELECT * FROM aircrafts_tmp;