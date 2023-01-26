DROP DATABASE IF EXISTS keycloak;
DROP USER IF EXISTS keycloak;

CREATE USER keycloak WITH PASSWORD 'keycloak';
CREATE DATABASE keycloak;
GRANT ALL ON DATABASE keycloak TO root WITH GRANT OPTION;