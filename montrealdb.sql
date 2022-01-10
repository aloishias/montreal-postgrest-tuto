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


create role postgrestRole nologin;

grant usage on schema montreal to postgrestRole;
grant all on montreal.accounts to postgrestRole;
grant all on montreal.mangas to postgrestRole;

create role authenticator noinherit login password 'root';
grant postgrestRole to authenticator;