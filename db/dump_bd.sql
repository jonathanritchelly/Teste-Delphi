CREATE DATABASE  IF NOT EXISTS `teste_delphi` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `teste_delphi`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: teste_delphi
-- ------------------------------------------------------
-- Server version	5.7.43-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) DEFAULT NULL,
  `cidade` varchar(50) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Ana','Campinas','SP'),(2,'Carlos','Rio de Janeiro','RJ'),(3,'Mariana','Belo Horizonte','MG'),(4,'Roberto','Salvador','BA'),(5,'Fernanda','Curitiba','PR'),(6,'Lucas','São Paulo','SP'),(7,'Juliana','Porto Alegre','RS'),(8,'Pedro','Recife','PE'),(9,'Bianca','Florianópolis','SC'),(10,'Eduardo','Fortaleza','CE'),(11,'Paula','Manaus','AM'),(12,'Rafael','Brasília','DF'),(13,'Sofia','Natal','RN'),(14,'Felipe','Belém','PA'),(15,'Isabela','São Luís','MA'),(16,'Ricardo','Maceió','AL'),(17,'Júlia','Aracaju','SE'),(18,'Marcelo','João Pessoa','PB'),(19,'Gabriela','Campo Grande','MS'),(20,'Thiago','Vitória','ES'),(21,'Bruna','Goiânia','GO');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_dados_gerais`
--

DROP TABLE IF EXISTS `pedidos_dados_gerais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_dados_gerais` (
  `numero_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `data_emissao` datetime DEFAULT NULL,
  `codigo_cliente` int(11) DEFAULT NULL,
  `valor_total` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `FK_Cliente_idx` (`codigo_cliente`),
  CONSTRAINT `FK_Cliente` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_dados_gerais`
--

LOCK TABLES `pedidos_dados_gerais` WRITE;
/*!40000 ALTER TABLE `pedidos_dados_gerais` DISABLE KEYS */;
INSERT INTO `pedidos_dados_gerais` VALUES (1,'2024-10-14 14:12:13',15,33.40),(3,'2024-10-14 15:06:13',15,215.90);
/*!40000 ALTER TABLE `pedidos_dados_gerais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `pedidos_produtos_id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` int(11) DEFAULT NULL,
  `codigo_produto` int(11) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL,
  `valor_unitario` decimal(10,2) DEFAULT NULL,
  `valor_total` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`pedidos_produtos_id`),
  KEY `FK_Pedido_idx` (`numero_pedido`),
  KEY `FK_Produto_idx` (`codigo_produto`),
  CONSTRAINT `FK_Pedido` FOREIGN KEY (`numero_pedido`) REFERENCES `pedidos_dados_gerais` (`numero_pedido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Produto` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` VALUES (4,3,1,5,32.70,163.50),(5,3,2,5,7.90,39.50),(6,3,3,3,4.30,12.90);
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(150) DEFAULT NULL,
  `preco_de_venda` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Arroz 5kg',25.50),(2,'Feijão preto 1kg',7.90),(3,'Macarrão 500g',4.30),(4,'Óleo de soja 900ml',6.75),(5,'Leite integral 1L',4.80),(6,'Café 500g',12.20),(7,'Açúcar refinado 1kg',3.40),(8,'Farinha de trigo 1kg',5.90),(9,'Sal 1kg',1.99),(10,'Margarina 500g',6.30),(11,'Detergente líquido 500ml',2.75),(12,'Amaciante 2L',11.50),(13,'Papel higiênico 12 rolos',15.90),(14,'Shampoo 300ml',18.30),(15,'Creme dental 90g',4.50),(16,'Água sanitária 1L',3.10),(17,'Desinfetante 500ml',7.20),(18,'Sabonete 90g',1.80),(19,'Alvejante sem cloro 1L',8.90),(20,'Biscoito recheado 130g',3.70);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-14 15:31:29
