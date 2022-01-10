# Montreal postgrest:

Projet postgrest basé sur la base de données du projet Montreal.


## Objectif:

L'objectif est de mettre en place une API Restful avec postgrest sur OSX.

## Configuration base de données:

Dans un premier temp créer le schéma et le modèle de la base de données:

```sql
CREATE SCHEMA montreal;

CREATE TABLE montreal.accounts (
  accountId INT GENERATED ALWAYS AS IDENTITY,
  accountFirstName VARCHAR(30),
  accountLastName VARCHAR(30),
  accountLogin VARCHAR(30),
  accountPassword VARCHAR(30),
  PRIMARY KEY (accountId)
);

CREATE TABLE montreal.mangas (
  mangaId INT GENERATED ALWAYS AS IDENTITY,
  accountId INT,
  mangaTitle VARCHAR(30),
  mangaAuthor VARCHAR(30),
  mangaImageLink VARCHAR(30),
  mangaNumber VARCHAR(30),
  PRIMARY KEY (mangaId),
  CONSTRAINT fkAccount
      FOREIGN KEY(accountId) 
	  REFERENCES montreal.accounts(accountId)
);
```

Dans un second temps les rôles pour permettent à postgrest d'accéder à la base de données:

```sql
create role postgrestRole nologin;

grant usage on schema montreal to postgrestrole;
grant all on montreal.accounts to postgrestrole;
grant all on montreal.mangas to postgrestrole;

create role authenticator noinherit login password 'root';
grant postgrestrole to authenticator;
```

La on permet au rôle postgrestrole d'effectuer les action CRUD sur les tables accounts et mangas du schéma montreal.

## Configuration de Postgrest:

Postgrest s'appuie sur un fichier de configuration pour se connecter et intéragir avec la base de données, avec les rôle et la base de données installer ci-dessus cette exemple fonctionne:

```conf
db-uri = "postgres://authenticator:root@localhost:5432/postgres"
db-schema = "montreal"
db-anon-role = "postgrestrole"
```

Il faut ensuite se rendre dans le répertoire où se trouve votre fichier de configuration et executer la commande:
``` bash
postgrest montreal.conf
```

Dans cette exemple mon fichier de configuration s'appel montreal.conf mais le nom peut être différent.

Une fois la commande executer le serveur Postgrest et lancer et vous avez une API Restful.
