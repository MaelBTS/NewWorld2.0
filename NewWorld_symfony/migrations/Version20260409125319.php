<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260409125319 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE archive (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, type VARCHAR(255) NOT NULL, ancien_id INTEGER NOT NULL, data CLOB NOT NULL, date_archivage DATETIME NOT NULL)');
        $this->addSql('CREATE TABLE panier (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, statut VARCHAR(255) NOT NULL, date_facturation DATETIME DEFAULT NULL, date_livraison DATETIME DEFAULT NULL, commentaire CLOB DEFAULT NULL, user_id INTEGER NOT NULL, CONSTRAINT FK_24CC0DF2A76ED395 FOREIGN KEY (user_id) REFERENCES users (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_24CC0DF2A76ED395 ON panier (user_id)');
        $this->addSql('CREATE TABLE produit (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom VARCHAR(255) NOT NULL, producteur_id INTEGER NOT NULL, quantite_type_id INTEGER NOT NULL, CONSTRAINT FK_29A5EC27AB9BB300 FOREIGN KEY (producteur_id) REFERENCES producteur (id) NOT DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT FK_29A5EC277C0CF4F3 FOREIGN KEY (quantite_type_id) REFERENCES quantite_type (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_29A5EC27AB9BB300 ON produit (producteur_id)');
        $this->addSql('CREATE INDEX IDX_29A5EC277C0CF4F3 ON produit (quantite_type_id)');
        $this->addSql('CREATE TABLE produit_panier (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, quantite DOUBLE PRECISION NOT NULL, produit_id INTEGER NOT NULL, panier_id INTEGER NOT NULL, CONSTRAINT FK_D39EC6C8F347EFB FOREIGN KEY (produit_id) REFERENCES produit (id) NOT DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT FK_D39EC6C8F77D927C FOREIGN KEY (panier_id) REFERENCES panier (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_D39EC6C8F347EFB ON produit_panier (produit_id)');
        $this->addSql('CREATE INDEX IDX_D39EC6C8F77D927C ON produit_panier (panier_id)');
        $this->addSql('CREATE TABLE produit_sur_le_temps (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, prix_achat DOUBLE PRECISION NOT NULL, prix_vente DOUBLE PRECISION NOT NULL, tva DOUBLE PRECISION NOT NULL, quantite DOUBLE PRECISION NOT NULL, date_debut_prix_achat DATETIME NOT NULL, date_fin_prix_achat DATETIME NOT NULL, date_debut_prix_vente DATETIME NOT NULL, date_fin_prix_vente DATETIME NOT NULL, date_debut_tva DATETIME NOT NULL, date_fin_tva DATETIME NOT NULL)');
        $this->addSql('CREATE TABLE quantite_type (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, type VARCHAR(255) NOT NULL)');
        $this->addSql('DROP TABLE archive_producteur');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE archive_producteur (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ancien_id INTEGER NOT NULL, data CLOB NOT NULL COLLATE "BINARY", date_archivage DATETIME NOT NULL)');
        $this->addSql('DROP TABLE archive');
        $this->addSql('DROP TABLE panier');
        $this->addSql('DROP TABLE produit');
        $this->addSql('DROP TABLE produit_panier');
        $this->addSql('DROP TABLE produit_sur_le_temps');
        $this->addSql('DROP TABLE quantite_type');
    }
}
