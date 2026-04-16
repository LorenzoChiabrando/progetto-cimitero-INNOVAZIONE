-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Creato il: Mar 30, 2026 alle 14:57
-- Versione del server: 8.0.44
-- Versione PHP: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `omeka_s`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `1`
--

CREATE TABLE `1` (
  `prova` int NOT NULL,
  `prova2` int NOT NULL,
  `prova3` int NOT NULL,
  `prova4` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `api_key`
--

CREATE TABLE `api_key` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_id` int NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `credential_hash` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_ip` varbinary(16) DEFAULT NULL COMMENT '(DC2Type:ip_address)',
  `last_accessed` datetime DEFAULT NULL,
  `created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `asset`
--

CREATE TABLE `asset` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `media_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `storage_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alt_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `fulltext_search`
--

CREATE TABLE `fulltext_search` (
  `id` int NOT NULL,
  `resource` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_id` int DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `fulltext_search`
--

INSERT INTO `fulltext_search` (`id`, `resource`, `owner_id`, `is_public`, `title`, `text`) VALUES
(1, 'items', 1, 1, 'Violeta Parra', 'Violeta Parra\nCharacter\nVioleta Parra is one of the most significant cultural figures of 20th-century Chile. A singer-songwriter, artist and folklorist, she is regarded as a central figure in Chilean culture. On the guided tour of the General Cemetery, she is listed among the notable figures and is marked on the map in section P102. Her presence helps to define the cemetery as a space of national memory and an open-air museum.\nLocation: P102, General Cemetery of Santiago.\nMap\nHistorical figures'),
(4, 'media', 1, 1, NULL, ''),
(5, 'media', 1, 1, NULL, ''),
(6, 'items', 1, 1, 'Nazario Elguín\'s Mausoleum', 'Nazario Elguín\'s Mausoleum\nNazario Elguín\'s Mausoleum\nTebaldo Brugnoli\n1893\nThe Nazario Elguín Mausoleum is one of the most significant examples of exotic funerary architecture in the Cementerio General de Santiago. Designed in 1893 by the architect Tebaldo Brugnoli, it features one of the most daring examples of Mayan-Aztec style in the complex. The mausoleum incorporates symbolic elements such as the Aztec calendar and references to the figure of Coatlicue, expressing a strong stylistic freedom and rich iconography.\nIt represents a key example for interpreting the cemetery as a museum of architecture and a manifestation of the social dynamics of the era.\nLocation: P28.\nMap\nArchitettura funeraria'),
(8, 'media', 1, 1, NULL, ''),
(9, 'items', 1, 1, 'Patio 29', 'Patio 29\nPlace of remembrance\nPatio 29 is one of the most significant memorial sites in the Cementerio General de Santiago. It is known for housing the graves of disappeared detainees and victims of political executions during the Chilean dictatorship, and has become a symbol of collective memory and human rights violations.\nWithin the context of the digital project, it represents the historical and civic dimension of the cemetery, highlighting its role as a space of remembrance as well as a burial ground.\nLocation: 162.\nMap\nPlaces of remembrance'),
(11, 'media', 1, 1, NULL, ''),
(12, 'items', 1, 1, 'Map', 'Map\nThe general map of the Cementerio General de Santiago organises the site’s main points of interest, including historical figures, mausoleums, sculptures and memorial sites. These points are identified using a coordinate system (P1, P2, etc.), which allows each element to be located within the space.\nIn the digital project, the map serves as the central hub connecting the items, enabling spatial and thematic navigation of the cemetery.'),
(13, 'media', 1, 1, NULL, ''),
(14, 'items', 1, 1, 'Funeral architecture', 'Funeral architecture\nCategory\nThe funerary architecture of the Cementerio General de Santiago encompasses a wide variety of styles, including European and exotic influences. Mausoleums, chapels and monuments reflect the social, cultural and symbolic dynamics of Chilean society between the 19th and 20th centuries, transforming the cemetery into an open-air museum.'),
(15, 'items', 1, 1, 'Egyptian Mausoleum', 'Egyptian Mausoleum\nMausoleum\nThe Egyptian Mausoleum at the Cementerio General de Santiago is one of the most striking examples of exotic influence in Chilean funerary architecture. Featuring iconographic elements from ancient Egypt, such as pyramidal forms and symbols associated with death and eternity, the mausoleum reflects an interest in ancient and distant cultures.\nThis type of architecture bears witness to the elite’s desire to express prestige and distinction through international symbolic models.\nLocation: Patio 37.\nArchitettura funeraria\nMap'),
(16, 'media', 1, 1, NULL, ''),
(17, 'items', 1, 1, 'Gothic Mausoleum', 'Gothic Mausoleum \nMausoleum \nThe Gothic Mausoleum is an example of funerary architecture inspired by the European Neo-Gothic style. Characterised by pointed arches, vertical ornamentation and symbolic references to Christian spirituality, this type of mausoleum reflects the influence of European culture on the construction of the Chilean elite’s identity.\nThe presence of these elements helps to transform the cemetery into a complex and multi-layered architectural space.\nLocation: Patio 27\nMap\nArchitettura funeraria'),
(18, 'media', 1, 1, NULL, ''),
(19, 'items', 1, 1, 'Moorish Mausoleum', 'Moorish Mausoleum \nMausoleum \nThe Moorish Mausoleum is one of the most distinctive examples of funerary architecture in the General Cemetery. Inspired by Islamic art, it features decorative elements such as horseshoe arches and intricate ornamental motifs.\nThis style bears witness to the cultural diversity and creative freedom evident in the design of the mausoleums, highlighting the cemetery as a space for architectural and symbolic experimentation.\nLocation: Patio 17.\nMap\nArchitettura funeraria'),
(20, 'media', 1, 1, NULL, ''),
(21, 'media', 1, 1, NULL, ''),
(22, 'items', 1, 1, 'Historical figures', 'Historical figures \nCategory\nThe historical figures buried at the Cementerio General de Santiago include prominent figures from Chile’s political, cultural and social history. Among them are artists, intellectuals, political leaders and key figures in the nation’s history.\nWithin the digital project, this section enables users to organise and link the various figures buried in the cemetery, offering a thematic overview that complements the spatial view provided by the map.'),
(23, 'items', 1, 1, 'Salvador Allende', 'Salvador Allende\nCharacter \nSalvador Allende Gossens was a Chilean politician and President of the Republic of Chile from 1970 to 1973. A central figure in the country’s political history, he is known for his programme of social transformation and for the coup d’état that led to his death.\nHis presence in the Cementerio General makes him a key figure in Chile’s historical and political memory, placing him amongst the cemetery’s notable figures.\nLocation: Patio 50. \nMap\nHistorical figures\nPolitics; Chilean history; remembrance'),
(24, 'media', 1, 1, NULL, ''),
(25, 'media', 1, 1, NULL, ''),
(26, 'items', 1, 1, 'Andrés Bello', 'Andrés Bello\nCharacter \nAndrés Bello was a Venezuelan-born Chilean intellectual, jurist and humanist, and a key figure in Chile’s cultural and institutional development during the 19th century. He is renowned for his contributions to language, law and education, as well as for founding the University of Chile.\nHis presence in the General Cemetery is a key element in interpreting the cemetery as a space of the country’s cultural and intellectual memory.\nLocation: P16.\nMappa\nPersonaggi storici\nCulture; law; education; history'),
(27, 'media', 1, 1, NULL, ''),
(28, 'media', 1, 1, NULL, ''),
(29, 'items', 1, 1, 'Manuel Rodríguez', 'Manuel Rodríguez\nCharacter \nAt the Cementerio General, his presence contributes to the site’s historical and patriotic significance, reinforcing the cemetery’s role as a place of national remembrance.\nLocation: 38.\nMap\nHistorical figures\nIndependence; history; national identity'),
(30, 'media', 1, 1, NULL, ''),
(32, 'items', 1, 1, 'Italian Mausoleum', 'Italian Mausoleum \nMausoleum \n\nThe Italian Mausoleum exemplifies the influence of European funerary architecture within the Cementerio General de Santiago. Characterised by classical elements and formal symmetry, it reflects the architectural styles imported from Italy and adopted by the Chilean elite between the 19th and 20th centuries.\nLocation: Patio 15.\nMap\nFuneral architecture'),
(33, 'items', 1, 1, 'Capilla Verde', ' Capilla Verde\nFunerary structure\nThe Capilla Verde is one of the most recognisable architectural features of the General Cemetery. It serves as a ceremonial and symbolic space, contributing to the cemetery’s religious and ritual dimension.\nLocation: Courtyard 42.\nMap\nArchitettura funeraria'),
(34, 'media', 1, 1, NULL, ''),
(35, 'items', 1, 1, 'Places of remembrance', 'Places of remembrance \nCategory\nThe memorial sites within the Cementerio General include areas linked to Chile’s political and social history, particularly the memory of the dictatorship and human rights violations. This section enables users to link and organize the cemetery’s significant sites from a historical and commemorative perspective.'),
(36, 'items', 1, 1, 'Patio Histórico', ' Patio Histórico\nPlace of remembrance\nThe Patio Histórico is one of the oldest areas of the Cementerio General, characterised by the presence of historic graves and significant monuments. It is a key site for understanding the cemetery’s historical development.\nLocation: Patio 05.\nMap\nLuoghi della memoria'),
(37, 'media', 1, 1, NULL, ''),
(38, 'items', 1, 1, 'Patio de Disidentes', 'Patio de Disidentes\nPlace of remembrance\nThe Patio de Disidentes is a space set aside for people who do not belong to the Catholic faith, representing an important aspect of religious and cultural diversity within the cemetery.\nLocation: Patio 01.\nMap\nLuoghi della memoria'),
(39, 'media', 1, 1, NULL, ''),
(40, 'items', 1, 1, 'Political tour', 'Political tour\nThematic tour\nThe political tour of the Cementerio General explores places and figures linked to Chile’s political history, offering an interpretation of the cemetery as a space of national memory.\nThrough figures such as Salvador Allende and symbolic sites such as Patio 29, the tour highlights the cemetery’s role in preserving collective memory and representing the most significant moments in the country’s political history.\nPatio 29\nSalvador Allende'),
(41, 'items', 1, 1, 'Artistic tour', 'Artistic tour\nThematic tour\nThe Cementerio General’s artistic journey highlights figures and elements linked to cultural and artistic production.\nThrough figures such as Violeta Parra, the cemetery is interpreted not only as a place of burial, but also as a space for artistic and symbolic expression, capable of telling the cultural history of Chile.\nVioleta Parra'),
(42, 'items', 1, 1, 'Architectural tour', 'Architectural tour\nThematic tour\nThe architectural tour of the General Cemetery highlights the variety of styles and influences found in the site’s funerary architecture.\nThrough mausoleums and structures such as the Green Chapel, the tour demonstrates how the cemetery functions as an open-air museum, characterized by a rich cultural and architectural heritage.\nMoorish Mausoleum\nEgyptian Mausoleum\nGothic Mausoleum\nItalian Mausoleum\nNazario Elguín\'s Mausoleum\nCapilla Verde'),
(43, 'item_sets', 1, 1, 'Historical figures', 'Historical figures\nA collection of historical and cultural figures.'),
(44, 'item_sets', 1, 1, 'Funeral Architecture', 'Funeral Architecture\nA collection of the architectural and funerary features of the cemetery, including mausoleums and other structures.'),
(45, 'item_sets', 1, 1, 'Places of remembrance', 'Places of remembrance\n A collection of sites linked to the historical and social heritage of the cemetery.'),
(46, 'item_sets', 1, 1, 'Themed tours', 'Themed tours\nA collection of the interpretative trails created as part of the project.'),
(47, 'media', 1, 1, NULL, ''),
(48, 'media', 1, 1, NULL, ''),
(49, 'media', 1, 1, NULL, ''),
(50, 'media', 1, 1, NULL, ''),
(51, 'media', 1, 1, NULL, ''),
(52, 'media', 1, 1, NULL, ''),
(54, 'media', 1, 1, NULL, ''),
(55, 'media', 1, 1, NULL, ''),
(56, 'media', 1, 1, NULL, '');

-- --------------------------------------------------------

--
-- Struttura della tabella `item`
--

CREATE TABLE `item` (
  `id` int NOT NULL,
  `primary_media_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `item`
--

INSERT INTO `item` (`id`, `primary_media_id`) VALUES
(14, NULL),
(22, NULL),
(32, NULL),
(35, NULL),
(40, NULL),
(41, NULL),
(42, NULL),
(1, 5),
(12, 13),
(15, 16),
(17, 18),
(6, 20),
(19, 21),
(23, 24),
(26, 27),
(29, 30),
(33, 34),
(36, 37),
(38, 39),
(9, 49);

-- --------------------------------------------------------

--
-- Struttura della tabella `item_item_set`
--

CREATE TABLE `item_item_set` (
  `item_id` int NOT NULL,
  `item_set_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `item_item_set`
--

INSERT INTO `item_item_set` (`item_id`, `item_set_id`) VALUES
(1, 43),
(6, 44),
(9, 45),
(15, 44),
(17, 44),
(19, 44),
(23, 43),
(26, 43),
(29, 43),
(32, 44),
(33, 44),
(36, 45),
(38, 45),
(40, 46),
(41, 46);

-- --------------------------------------------------------

--
-- Struttura della tabella `item_set`
--

CREATE TABLE `item_set` (
  `id` int NOT NULL,
  `is_open` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `item_set`
--

INSERT INTO `item_set` (`id`, `is_open`) VALUES
(43, 0),
(44, 0),
(45, 0),
(46, 0);

-- --------------------------------------------------------

--
-- Struttura della tabella `item_site`
--

CREATE TABLE `item_site` (
  `item_id` int NOT NULL,
  `site_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `item_site`
--

INSERT INTO `item_site` (`item_id`, `site_id`) VALUES
(1, 1),
(6, 1),
(9, 1),
(12, 1),
(14, 1),
(15, 1),
(17, 1),
(19, 1),
(22, 1),
(23, 1),
(26, 1),
(29, 1),
(32, 1),
(33, 1),
(35, 1),
(36, 1),
(38, 1),
(40, 1),
(41, 1),
(42, 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `job`
--

CREATE TABLE `job` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `pid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `args` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '(DC2Type:json_array)',
  `log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `started` datetime NOT NULL,
  `ended` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `media`
--

CREATE TABLE `media` (
  `id` int NOT NULL,
  `item_id` int NOT NULL,
  `ingester` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `renderer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '(DC2Type:json_array)',
  `source` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `media_type` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `storage_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extension` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sha256` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` bigint DEFAULT NULL,
  `has_original` tinyint(1) NOT NULL,
  `has_thumbnails` tinyint(1) NOT NULL,
  `position` int DEFAULT NULL,
  `lang` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alt_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `media`
--

INSERT INTO `media` (`id`, `item_id`, `ingester`, `renderer`, `data`, `source`, `media_type`, `storage_id`, `extension`, `sha256`, `size`, `has_original`, `has_thumbnails`, `position`, `lang`, `alt_text`) VALUES
(4, 1, 'upload', 'file', NULL, 'tomba_parra.jpg', 'image/jpeg', 'dc08bb381d66a159bbdfcd399981a8a9f217c879', 'jpg', '67baed351837a824c44dc3317f8903dd5fa4884a2cdabc68c2826d8149f3165e', 125536, 1, 1, 3, NULL, NULL),
(5, 1, 'upload', 'file', NULL, 'parra.jpg', 'image/jpeg', '7607215253811c771d667fd8fadf4745f1cd6234', 'jpg', 'ef6ba07ee88ec8d2cd23d6077519c0bd814de8054a8985eb478462be5bb4b941', 208699, 1, 1, 1, NULL, NULL),
(8, 6, 'upload', 'file', NULL, 'Cementerios Exóticos del Cementerio General.pdf', 'application/pdf', 'fadebaaf7347a9cb57535090b825ac7fbaf95c43', 'pdf', '19bcc325ac0ffe2b7d96ebef8131f47a99d1a1dd6a633ebb175413ee9ac39b14', 179360, 1, 0, 1, NULL, NULL),
(11, 9, 'upload', 'file', NULL, '01.__PLANO_OFICIAL_DE_CG___EDIFICACIONES_PLANO_CATASTRAL.pdf', 'application/pdf', '5f7b3a4d4917ab107f27809863ebf58d1d9f7853', 'pdf', 'a2a2a4db2e6f84d827545a3e37eb1cc3d664e982fdaa2d78e3f9d221e662d815', 838348, 1, 0, 4, NULL, NULL),
(13, 12, 'upload', 'file', NULL, '01.__PLANO_OFICIAL_DE_CG___EDIFICACIONES_PLANO_CATASTRAL.pdf', 'application/pdf', 'c62685d3c098260f67a0cdc97b1297320d4924c1', 'pdf', 'a2a2a4db2e6f84d827545a3e37eb1cc3d664e982fdaa2d78e3f9d221e662d815', 838348, 1, 0, 1, NULL, NULL),
(16, 15, 'upload', 'file', NULL, 'mausoleo_egizio.png', 'image/png', '6c25205b1800e4868269a6627618dec4c88dec77', 'png', 'aa57310ad3f3f2d93a776515cdc041d6ee53da8c2ec37c40fdf3b81486d78d02', 66416, 1, 1, 1, NULL, NULL),
(18, 17, 'upload', 'file', NULL, 'catr_gotica.jpg', 'image/jpeg', 'bc2f9fb09f0feacc04535e3d34595fed85bd4f5f', 'jpg', '6dfa207844657f33485a33dfeab39ce574b14590222540fbdec343499b170efa', 65238, 1, 1, 1, NULL, NULL),
(20, 6, 'upload', 'file', NULL, 'Mausoleo_Nazario_Elguín.jpg', 'image/jpeg', '360fb0212e3463e5b7a8cc0da515edebf8dd5a75', 'jpg', '7d7dd9525fc4b9a0178552dd0b5f0ab346fd5133178bbe26908a81f9bb854721', 726711, 1, 1, 2, NULL, NULL),
(21, 19, 'upload', 'file', NULL, 'maus_morisco.png', 'image/png', 'e18a7fbb62b8c8eae5f0224feaeecda6379377dc', 'png', 'bebc45fd6d7516b938f2aeaa386ddb4c75ec832ff8b5947ca1e8f147b3cc8e43', 110617, 1, 1, 1, NULL, NULL),
(24, 23, 'upload', 'file', NULL, 'Salvador_Allende.jpg', 'image/jpeg', '9a7248ef9bc15549291a84f11b1f6c5481329367', 'jpg', '0fb1a8a398a4dea9d9930e9100beebae1d90977bf66d9399f4c4df9586b2514d', 91071, 1, 1, 1, NULL, NULL),
(25, 23, 'upload', 'file', NULL, 'Tomba_Allende.jpg', 'image/jpeg', 'c3e61c79e6ad995f32e77d82bc1521affde23301', 'jpg', '9684b912c478f96cd900d0764772f51683512c0847b6dbecd480f40ca13c195f', 31189, 1, 1, 3, NULL, NULL),
(27, 26, 'upload', 'file', NULL, 'Andres_Bello.jpeg', 'image/jpeg', 'b4ff091b0165996cf2bad37e585e02c1ed6db2a6', 'jpeg', '8e5df7ac97117128db6f992f0523d90d00c239c480371b8a5aad011e15a0e125', 77323, 1, 1, 1, NULL, NULL),
(28, 26, 'upload', 'file', NULL, 'TumbaBello.jpeg', 'image/jpeg', 'd1785dae5eea0488e181c3b70db502f55af65541', 'jpeg', '1a1c5d2b23a188c75e11386c6f5d363ef081abd218f4ef47c9be1717b78d5ccf', 203518, 1, 1, 2, NULL, NULL),
(30, 29, 'upload', 'file', NULL, 'ManuelRodrigez.jpg', 'image/jpeg', 'b1aa43ed09b10d0b09001995898db182c6aba9d5', 'jpg', '0620f8adf9f053a16e009b5908084ecf397adad5912becf3436481269d994de1', 449565, 1, 1, 1, NULL, NULL),
(34, 33, 'upload', 'file', NULL, 'capilla_verde.jpeg', 'image/jpeg', 'f44da7e81628d5e092f53295af115ccab44260e5', 'jpeg', '15216f8d6c548bec85b4aa9bed0e6c2b8bbf5ffdef47011bf46c0ce0af01a384', 99670, 1, 1, 1, NULL, NULL),
(37, 36, 'upload', 'file', NULL, 'patio_historia.jpg', 'image/jpeg', '136866c9c4307be1b1613c38424e6b005092f8ce', 'jpg', '672f3348e64436f853e4ac23f88625112b519f7ab88a6e58d443080789619b69', 208100, 1, 1, 1, NULL, NULL),
(39, 38, 'upload', 'file', NULL, 'Cementerio_n1.jpg', 'image/jpeg', 'dde8ba8b20a3424e4524703e9be06645579c9969', 'jpg', 'df9f3b9f6cec442d2f57251f61ec8e48ba93af90109f9bd0dc438c6c1da3143b', 173295, 1, 1, 1, NULL, NULL),
(47, 32, 'upload', 'file', NULL, 'MAUSOLEO_ITALIANO_4.jpeg', 'image/jpeg', '559d06144b5d2ed17be3a9cec4ba22f06aa9152c', 'jpeg', '7d7e09f6072146ad68f274707087a49d1d1da75995da8ccafd021768f954be37', 649896, 1, 1, 1, NULL, NULL),
(48, 32, 'upload', 'file', NULL, 'UBICACIÓN.pdf', 'application/pdf', '34ba27f8cc2d27b1a8e27c3165669e8b50ec5730', 'pdf', '3f3ecd30a10db31d24c9e7817d28bb5826cebb50ad89923ae1d30f7e351d60db', 578080, 1, 0, 2, NULL, NULL),
(49, 9, 'upload', 'file', NULL, 'Patio 29 3 - Sepúlveda, 2026.jpeg.jpeg', 'image/jpeg', '6a26eec8a59882f5c2453f684747bc95273422ca', 'jpeg', '883ffb3c41c10740cd8bae4016e6f0957fa52c983b0a44b746fece8ed0d193cf', 1231039, 1, 1, 1, NULL, NULL),
(50, 9, 'upload', 'file', NULL, 'NN Patio 29 - Alan Lecaros - 2025.jpg', 'image/jpeg', '8cba7807d46cb316673b96f69f7597ba1619901d', 'jpg', '18a243e7fe373178b20ddac4f3dc3bd147eabaf5ea100e130dc27b2fc7067fab', 2240238, 1, 1, 2, NULL, NULL),
(51, 9, 'upload', 'file', NULL, 'Patio 29 - CMN - 2006.jpg', 'image/jpeg', '679a514e219798348b46d1de4fe1408c4fe90d5e', 'jpg', '378402459e6aa2bbff47ec2c6ab9ff50e7a66c9f520a6d5b6d6f0f42c1b7d48a', 2250860, 1, 1, 3, NULL, NULL),
(52, 1, 'upload', 'file', NULL, 'Tumba de Violeta Parra - Museo Violeta Parra - 2018.jpg', 'image/jpeg', '6996a77c387969a07cc58698a2b2420b770fa3ff', 'jpg', '5a38c9bcfe984420ca02ad8f5ef78489038da769f3c7394327d2f9c92e5d5aa5', 360548, 1, 1, 2, NULL, NULL),
(54, 23, 'upload', 'file', NULL, 'Tumba Salvador Allende - Lecaros 2025.jpg', 'image/jpeg', '8373325d16ff1aa71bcba762ee1c4785048ed1bd', 'jpg', '9a7ba9529c1a40759c33878835df07aae9c50af6810884d12f7f5ede8c16aa9f', 1354468, 1, 1, 2, NULL, NULL),
(55, 29, 'upload', 'file', NULL, 'Tumba_de_Manuel_Rodriguez - wikipedia - 2016.jpg', 'image/jpeg', 'd5c013b054aac2bf71c2b7f91656f262a080063c', 'jpg', '7b0259ec3877943cd18e6f0726657138f29fadd660752af561aebe044a659541', 182174, 1, 1, 2, NULL, NULL),
(56, 1, 'upload', 'file', NULL, '5. Violeta Parra.pdf', 'application/pdf', 'aa5db04fd4f73c31746b8f98eca428c1ccb5c58f', 'pdf', '19fae87c1e86c04df31500f538dd255b0f10c7a1115ae57af27d372d99f2d361', 87301307, 1, 0, 4, NULL, NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `migration`
--

CREATE TABLE `migration` (
  `version` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `migration`
--

INSERT INTO `migration` (`version`) VALUES
('20171128053327'),
('20180412035023'),
('20180919072656'),
('20180924033501'),
('20181002015551'),
('20181004043735'),
('20181106060421'),
('20190307043537'),
('20190319020708'),
('20190412090532'),
('20190423040354'),
('20190423071228'),
('20190514061351'),
('20190515055359'),
('20190729023728'),
('20190809092609'),
('20190815062003'),
('20200224022356'),
('20200226064602'),
('20200325091157'),
('20200326091310'),
('20200803000000'),
('20200831000000'),
('20210205101827'),
('20210225095734'),
('20210810083804'),
('20220718090449'),
('20220824103916'),
('20230124033031'),
('20230410074846'),
('20230523085358'),
('20230601060113'),
('20230713101012'),
('20231016000000'),
('20240103030617'),
('20240219000000'),
('20240614123811');

-- --------------------------------------------------------

--
-- Struttura della tabella `module`
--

CREATE TABLE `module` (
  `id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `password_creation`
--

CREATE TABLE `password_creation` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` int NOT NULL,
  `created` datetime NOT NULL,
  `activate` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `property`
--

CREATE TABLE `property` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `vocabulary_id` int NOT NULL,
  `local_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `property`
--

INSERT INTO `property` (`id`, `owner_id`, `vocabulary_id`, `local_name`, `label`, `comment`) VALUES
(1, NULL, 1, 'title', 'Title', 'A name given to the resource.'),
(2, NULL, 1, 'creator', 'Creator', 'An entity primarily responsible for making the resource.'),
(3, NULL, 1, 'subject', 'Subject', 'The topic of the resource.'),
(4, NULL, 1, 'description', 'Description', 'An account of the resource.'),
(5, NULL, 1, 'publisher', 'Publisher', 'An entity responsible for making the resource available.'),
(6, NULL, 1, 'contributor', 'Contributor', 'An entity responsible for making contributions to the resource.'),
(7, NULL, 1, 'date', 'Date', 'A point or period of time associated with an event in the lifecycle of the resource.'),
(8, NULL, 1, 'type', 'Type', 'The nature or genre of the resource.'),
(9, NULL, 1, 'format', 'Format', 'The file format, physical medium, or dimensions of the resource.'),
(10, NULL, 1, 'identifier', 'Identifier', 'An unambiguous reference to the resource within a given context.'),
(11, NULL, 1, 'source', 'Source', 'A related resource from which the described resource is derived.'),
(12, NULL, 1, 'language', 'Language', 'A language of the resource.'),
(13, NULL, 1, 'relation', 'Relation', 'A related resource.'),
(14, NULL, 1, 'coverage', 'Coverage', 'The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.'),
(15, NULL, 1, 'rights', 'Rights', 'Information about rights held in and over the resource.'),
(16, NULL, 1, 'audience', 'Audience', 'A class of entity for whom the resource is intended or useful.'),
(17, NULL, 1, 'alternative', 'Alternative Title', 'An alternative name for the resource.'),
(18, NULL, 1, 'tableOfContents', 'Table Of Contents', 'A list of subunits of the resource.'),
(19, NULL, 1, 'abstract', 'Abstract', 'A summary of the resource.'),
(20, NULL, 1, 'created', 'Date Created', 'Date of creation of the resource.'),
(21, NULL, 1, 'valid', 'Date Valid', 'Date (often a range) of validity of a resource.'),
(22, NULL, 1, 'available', 'Date Available', 'Date (often a range) that the resource became or will become available.'),
(23, NULL, 1, 'issued', 'Date Issued', 'Date of formal issuance (e.g., publication) of the resource.'),
(24, NULL, 1, 'modified', 'Date Modified', 'Date on which the resource was changed.'),
(25, NULL, 1, 'extent', 'Extent', 'The size or duration of the resource.'),
(26, NULL, 1, 'medium', 'Medium', 'The material or physical carrier of the resource.'),
(27, NULL, 1, 'isVersionOf', 'Is Version Of', 'A related resource of which the described resource is a version, edition, or adaptation.'),
(28, NULL, 1, 'hasVersion', 'Has Version', 'A related resource that is a version, edition, or adaptation of the described resource.'),
(29, NULL, 1, 'isReplacedBy', 'Is Replaced By', 'A related resource that supplants, displaces, or supersedes the described resource.'),
(30, NULL, 1, 'replaces', 'Replaces', 'A related resource that is supplanted, displaced, or superseded by the described resource.'),
(31, NULL, 1, 'isRequiredBy', 'Is Required By', 'A related resource that requires the described resource to support its function, delivery, or coherence.'),
(32, NULL, 1, 'requires', 'Requires', 'A related resource that is required by the described resource to support its function, delivery, or coherence.'),
(33, NULL, 1, 'isPartOf', 'Is Part Of', 'A related resource in which the described resource is physically or logically included.'),
(34, NULL, 1, 'hasPart', 'Has Part', 'A related resource that is included either physically or logically in the described resource.'),
(35, NULL, 1, 'isReferencedBy', 'Is Referenced By', 'A related resource that references, cites, or otherwise points to the described resource.'),
(36, NULL, 1, 'references', 'References', 'A related resource that is referenced, cited, or otherwise pointed to by the described resource.'),
(37, NULL, 1, 'isFormatOf', 'Is Format Of', 'A related resource that is substantially the same as the described resource, but in another format.'),
(38, NULL, 1, 'hasFormat', 'Has Format', 'A related resource that is substantially the same as the pre-existing described resource, but in another format.'),
(39, NULL, 1, 'conformsTo', 'Conforms To', 'An established standard to which the described resource conforms.'),
(40, NULL, 1, 'spatial', 'Spatial Coverage', 'Spatial characteristics of the resource.'),
(41, NULL, 1, 'temporal', 'Temporal Coverage', 'Temporal characteristics of the resource.'),
(42, NULL, 1, 'mediator', 'Mediator', 'An entity that mediates access to the resource and for whom the resource is intended or useful.'),
(43, NULL, 1, 'dateAccepted', 'Date Accepted', 'Date of acceptance of the resource.'),
(44, NULL, 1, 'dateCopyrighted', 'Date Copyrighted', 'Date of copyright.'),
(45, NULL, 1, 'dateSubmitted', 'Date Submitted', 'Date of submission of the resource.'),
(46, NULL, 1, 'educationLevel', 'Audience Education Level', 'A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.'),
(47, NULL, 1, 'accessRights', 'Access Rights', 'Information about who can access the resource or an indication of its security status.'),
(48, NULL, 1, 'bibliographicCitation', 'Bibliographic Citation', 'A bibliographic reference for the resource.'),
(49, NULL, 1, 'license', 'License', 'A legal document giving official permission to do something with the resource.'),
(50, NULL, 1, 'rightsHolder', 'Rights Holder', 'A person or organization owning or managing rights over the resource.'),
(51, NULL, 1, 'provenance', 'Provenance', 'A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.'),
(52, NULL, 1, 'instructionalMethod', 'Instructional Method', 'A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.'),
(53, NULL, 1, 'accrualMethod', 'Accrual Method', 'The method by which items are added to a collection.'),
(54, NULL, 1, 'accrualPeriodicity', 'Accrual Periodicity', 'The frequency with which items are added to a collection.'),
(55, NULL, 1, 'accrualPolicy', 'Accrual Policy', 'The policy governing the addition of items to a collection.'),
(56, NULL, 3, 'affirmedBy', 'affirmedBy', 'A legal decision that affirms a ruling.'),
(57, NULL, 3, 'annotates', 'annotates', 'Critical or explanatory note for a Document.'),
(58, NULL, 3, 'authorList', 'list of authors', 'An ordered list of authors. Normally, this list is seen as a priority list that order authors by importance.'),
(59, NULL, 3, 'citedBy', 'cited by', 'Relates a document to another document that cites the\nfirst document.'),
(60, NULL, 3, 'cites', 'cites', 'Relates a document to another document that is cited\nby the first document as reference, comment, review, quotation or for\nanother purpose.'),
(61, NULL, 3, 'contributorList', 'list of contributors', 'An ordered list of contributors. Normally, this list is seen as a priority list that order contributors by importance.'),
(62, NULL, 3, 'court', 'court', 'A court associated with a legal document; for example, that which issues a decision.'),
(63, NULL, 3, 'degree', 'degree', 'The thesis degree.'),
(64, NULL, 3, 'director', 'director', 'A Film director.'),
(65, NULL, 3, 'distributor', 'distributor', 'Distributor of a document or a collection of documents.'),
(66, NULL, 3, 'editor', 'editor', 'A person having managerial and sometimes policy-making responsibility for the editorial part of a publishing firm or of a newspaper, magazine, or other publication.'),
(67, NULL, 3, 'editorList', 'list of editors', 'An ordered list of editors. Normally, this list is seen as a priority list that order editors by importance.'),
(68, NULL, 3, 'interviewee', 'interviewee', 'An agent that is interviewed by another agent.'),
(69, NULL, 3, 'interviewer', 'interviewer', 'An agent that interview another agent.'),
(70, NULL, 3, 'issuer', 'issuer', 'An entity responsible for issuing often informally published documents such as press releases, reports, etc.'),
(71, NULL, 3, 'organizer', 'organizer', 'The organizer of an event; includes conference organizers, but also government agencies or other bodies that are responsible for conducting hearings.'),
(72, NULL, 3, 'owner', 'owner', 'Owner of a document or a collection of documents.'),
(73, NULL, 3, 'performer', 'performer', NULL),
(74, NULL, 3, 'presentedAt', 'presented at', 'Relates a document to an event; for example, a paper to a conference.'),
(75, NULL, 3, 'presents', 'presents', 'Relates an event to associated documents; for example, conference to a paper.'),
(76, NULL, 3, 'producer', 'producer', 'Producer of a document or a collection of documents.'),
(77, NULL, 3, 'recipient', 'recipient', 'An agent that receives a communication document.'),
(78, NULL, 3, 'reproducedIn', 'reproducedIn', 'The resource in which another resource is reproduced.'),
(79, NULL, 3, 'reversedBy', 'reversedBy', 'A legal decision that reverses a ruling.'),
(80, NULL, 3, 'reviewOf', 'review of', 'Relates a review document to a reviewed thing (resource, item, etc.).'),
(81, NULL, 3, 'status', 'status', 'The publication status of (typically academic) content.'),
(82, NULL, 3, 'subsequentLegalDecision', 'subsequentLegalDecision', 'A legal decision on appeal that takes action on a case (affirming it, reversing it, etc.).'),
(83, NULL, 3, 'transcriptOf', 'transcript of', 'Relates a document to some transcribed original.'),
(84, NULL, 3, 'translationOf', 'translation of', 'Relates a translated document to the original document.'),
(85, NULL, 3, 'translator', 'translator', 'A person who translates written document from one language to another.'),
(86, NULL, 3, 'abstract', 'abstract', 'A summary of the resource.'),
(87, NULL, 3, 'argued', 'date argued', 'The date on which a legal case is argued before a court. Date is of format xsd:date'),
(88, NULL, 3, 'asin', 'asin', NULL),
(89, NULL, 3, 'chapter', 'chapter', 'An chapter number'),
(90, NULL, 3, 'coden', 'coden', NULL),
(91, NULL, 3, 'content', 'content', 'This property is for a plain-text rendering of the content of a Document. While the plain-text content of an entire document could be described by this property.'),
(92, NULL, 3, 'doi', 'doi', NULL),
(93, NULL, 3, 'eanucc13', 'eanucc13', NULL),
(94, NULL, 3, 'edition', 'edition', 'The name defining a special edition of a document. Normally its a literal value composed of a version number and words.'),
(95, NULL, 3, 'eissn', 'eissn', NULL),
(96, NULL, 3, 'gtin14', 'gtin14', NULL),
(97, NULL, 3, 'handle', 'handle', NULL),
(98, NULL, 3, 'identifier', 'identifier', NULL),
(99, NULL, 3, 'isbn', 'isbn', NULL),
(100, NULL, 3, 'isbn10', 'isbn10', NULL),
(101, NULL, 3, 'isbn13', 'isbn13', NULL),
(102, NULL, 3, 'issn', 'issn', NULL),
(103, NULL, 3, 'issue', 'issue', 'An issue number'),
(104, NULL, 3, 'lccn', 'lccn', NULL),
(105, NULL, 3, 'locator', 'locator', 'A description (often numeric) that locates an item within a containing document or collection.'),
(106, NULL, 3, 'numPages', 'number of pages', 'The number of pages contained in a document'),
(107, NULL, 3, 'numVolumes', 'number of volumes', 'The number of volumes contained in a collection of documents (usually a series, periodical, etc.).'),
(108, NULL, 3, 'number', 'number', 'A generic item or document number. Not to be confused with issue number.'),
(109, NULL, 3, 'oclcnum', 'oclcnum', NULL),
(110, NULL, 3, 'pageEnd', 'page end', 'Ending page number within a continuous page range.'),
(111, NULL, 3, 'pageStart', 'page start', 'Starting page number within a continuous page range.'),
(112, NULL, 3, 'pages', 'pages', 'A string of non-contiguous page spans that locate a Document within a Collection. Example: 23-25, 34, 54-56. For continuous page ranges, use the pageStart and pageEnd properties.'),
(113, NULL, 3, 'pmid', 'pmid', NULL),
(114, NULL, 3, 'prefixName', 'prefix name', 'The prefix of a name'),
(115, NULL, 3, 'section', 'section', 'A section number'),
(116, NULL, 3, 'shortDescription', 'shortDescription', NULL),
(117, NULL, 3, 'shortTitle', 'short title', 'The abbreviation of a title.'),
(118, NULL, 3, 'sici', 'sici', NULL),
(119, NULL, 3, 'suffixName', 'suffix name', 'The suffix of a name'),
(120, NULL, 3, 'upc', 'upc', NULL),
(121, NULL, 3, 'uri', 'uri', 'Universal Resource Identifier of a document'),
(122, NULL, 3, 'volume', 'volume', 'A volume number'),
(123, NULL, 4, 'mbox', 'personal mailbox', 'A  personal mailbox, ie. an Internet mailbox associated with exactly one owner, the first owner of this mailbox. This is a \'static inverse functional property\', in that  there is (across time and change) at most one individual that ever has any particular value for foaf:mbox.'),
(124, NULL, 4, 'mbox_sha1sum', 'sha1sum of a personal mailbox URI name', 'The sha1sum of the URI of an Internet mailbox associated with exactly one owner, the  first owner of the mailbox.'),
(125, NULL, 4, 'gender', 'gender', 'The gender of this Agent (typically but not necessarily \'male\' or \'female\').'),
(126, NULL, 4, 'geekcode', 'geekcode', 'A textual geekcode for this person, see http://www.geekcode.com/geek.html'),
(127, NULL, 4, 'dnaChecksum', 'DNA checksum', 'A checksum for the DNA of some thing. Joke.'),
(128, NULL, 4, 'sha1', 'sha1sum (hex)', 'A sha1sum hash, in hex.'),
(129, NULL, 4, 'based_near', 'based near', 'A location that something is based near, for some broadly human notion of near.'),
(130, NULL, 4, 'title', 'title', 'Title (Mr, Mrs, Ms, Dr. etc)'),
(131, NULL, 4, 'nick', 'nickname', 'A short informal nickname characterising an agent (includes login identifiers, IRC and other chat nicknames).'),
(132, NULL, 4, 'jabberID', 'jabber ID', 'A jabber ID for something.'),
(133, NULL, 4, 'aimChatID', 'AIM chat ID', 'An AIM chat ID'),
(134, NULL, 4, 'skypeID', 'Skype ID', 'A Skype ID'),
(135, NULL, 4, 'icqChatID', 'ICQ chat ID', 'An ICQ chat ID'),
(136, NULL, 4, 'yahooChatID', 'Yahoo chat ID', 'A Yahoo chat ID'),
(137, NULL, 4, 'msnChatID', 'MSN chat ID', 'An MSN chat ID'),
(138, NULL, 4, 'name', 'name', 'A name for some thing.'),
(139, NULL, 4, 'firstName', 'firstName', 'The first name of a person.'),
(140, NULL, 4, 'lastName', 'lastName', 'The last name of a person.'),
(141, NULL, 4, 'givenName', 'Given name', 'The given name of some person.'),
(142, NULL, 4, 'givenname', 'Given name', 'The given name of some person.'),
(143, NULL, 4, 'surname', 'Surname', 'The surname of some person.'),
(144, NULL, 4, 'family_name', 'family_name', 'The family name of some person.'),
(145, NULL, 4, 'familyName', 'familyName', 'The family name of some person.'),
(146, NULL, 4, 'phone', 'phone', 'A phone,  specified using fully qualified tel: URI scheme (refs: http://www.w3.org/Addressing/schemes.html#tel).'),
(147, NULL, 4, 'homepage', 'homepage', 'A homepage for some thing.'),
(148, NULL, 4, 'weblog', 'weblog', 'A weblog of some thing (whether person, group, company etc.).'),
(149, NULL, 4, 'openid', 'openid', 'An OpenID for an Agent.'),
(150, NULL, 4, 'tipjar', 'tipjar', 'A tipjar document for this agent, describing means for payment and reward.'),
(151, NULL, 4, 'plan', 'plan', 'A .plan comment, in the tradition of finger and \'.plan\' files.'),
(152, NULL, 4, 'made', 'made', 'Something that was made by this agent.'),
(153, NULL, 4, 'maker', 'maker', 'An agent that  made this thing.'),
(154, NULL, 4, 'img', 'image', 'An image that can be used to represent some thing (ie. those depictions which are particularly representative of something, eg. one\'s photo on a homepage).'),
(155, NULL, 4, 'depiction', 'depiction', 'A depiction of some thing.'),
(156, NULL, 4, 'depicts', 'depicts', 'A thing depicted in this representation.'),
(157, NULL, 4, 'thumbnail', 'thumbnail', 'A derived thumbnail image.'),
(158, NULL, 4, 'myersBriggs', 'myersBriggs', 'A Myers Briggs (MBTI) personality classification.'),
(159, NULL, 4, 'workplaceHomepage', 'workplace homepage', 'A workplace homepage of some person; the homepage of an organization they work for.'),
(160, NULL, 4, 'workInfoHomepage', 'work info homepage', 'A work info homepage of some person; a page about their work for some organization.'),
(161, NULL, 4, 'schoolHomepage', 'schoolHomepage', 'A homepage of a school attended by the person.'),
(162, NULL, 4, 'knows', 'knows', 'A person known by this person (indicating some level of reciprocated interaction between the parties).'),
(163, NULL, 4, 'interest', 'interest', 'A page about a topic of interest to this person.'),
(164, NULL, 4, 'topic_interest', 'topic_interest', 'A thing of interest to this person.'),
(165, NULL, 4, 'publications', 'publications', 'A link to the publications of this person.'),
(166, NULL, 4, 'currentProject', 'current project', 'A current project this person works on.'),
(167, NULL, 4, 'pastProject', 'past project', 'A project this person has previously worked on.'),
(168, NULL, 4, 'fundedBy', 'funded by', 'An organization funding a project or person.'),
(169, NULL, 4, 'logo', 'logo', 'A logo representing some thing.'),
(170, NULL, 4, 'topic', 'topic', 'A topic of some page or document.'),
(171, NULL, 4, 'primaryTopic', 'primary topic', 'The primary topic of some page or document.'),
(172, NULL, 4, 'focus', 'focus', 'The underlying or \'focal\' entity associated with some SKOS-described concept.'),
(173, NULL, 4, 'isPrimaryTopicOf', 'is primary topic of', 'A document that this thing is the primary topic of.'),
(174, NULL, 4, 'page', 'page', 'A page or document about this thing.'),
(175, NULL, 4, 'theme', 'theme', 'A theme.'),
(176, NULL, 4, 'account', 'account', 'Indicates an account held by this agent.'),
(177, NULL, 4, 'holdsAccount', 'account', 'Indicates an account held by this agent.'),
(178, NULL, 4, 'accountServiceHomepage', 'account service homepage', 'Indicates a homepage of the service provide for this online account.'),
(179, NULL, 4, 'accountName', 'account name', 'Indicates the name (identifier) associated with this online account.'),
(180, NULL, 4, 'member', 'member', 'Indicates a member of a Group'),
(181, NULL, 4, 'membershipClass', 'membershipClass', 'Indicates the class of individuals that are a member of a Group'),
(182, NULL, 4, 'birthday', 'birthday', 'The birthday of this Agent, represented in mm-dd string form, eg. \'12-31\'.'),
(183, NULL, 4, 'age', 'age', 'The age in years of some agent.'),
(184, NULL, 4, 'status', 'status', 'A string expressing what the user is happy for the general public (normally) to know about their current activity.');

-- --------------------------------------------------------

--
-- Struttura della tabella `resource`
--

CREATE TABLE `resource` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `resource_class_id` int DEFAULT NULL,
  `resource_template_id` int DEFAULT NULL,
  `thumbnail_id` int DEFAULT NULL,
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_public` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `resource_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `resource`
--

INSERT INTO `resource` (`id`, `owner_id`, `resource_class_id`, `resource_template_id`, `thumbnail_id`, `title`, `is_public`, `created`, `modified`, `resource_type`) VALUES
(1, 1, 94, 1, NULL, 'Violeta Parra', 1, '2026-03-23 19:09:48', '2026-03-30 14:56:33', 'Omeka\\Entity\\Item'),
(4, 1, NULL, NULL, NULL, NULL, 1, '2026-03-24 11:38:04', '2026-03-24 11:38:04', 'Omeka\\Entity\\Media'),
(5, 1, NULL, NULL, NULL, NULL, 1, '2026-03-24 11:40:45', '2026-03-24 11:40:45', 'Omeka\\Entity\\Media'),
(6, 1, 9, 1, NULL, 'Nazario Elguín\'s Mausoleum', 1, '2026-03-24 12:06:49', '2026-03-26 14:17:15', 'Omeka\\Entity\\Item'),
(8, 1, NULL, NULL, NULL, NULL, 1, '2026-03-24 12:07:07', '2026-03-24 12:07:07', 'Omeka\\Entity\\Media'),
(9, 1, 9, 1, NULL, 'Patio 29', 1, '2026-03-24 12:16:49', '2026-03-30 14:12:48', 'Omeka\\Entity\\Item'),
(11, 1, NULL, NULL, NULL, NULL, 1, '2026-03-24 12:16:49', '2026-03-24 12:16:49', 'Omeka\\Entity\\Media'),
(12, 1, 70, 1, NULL, 'Map', 1, '2026-03-24 22:28:45', '2026-03-26 14:01:12', 'Omeka\\Entity\\Item'),
(13, 1, NULL, NULL, NULL, NULL, 1, '2026-03-24 22:28:45', '2026-03-24 22:28:45', 'Omeka\\Entity\\Media'),
(14, 1, NULL, 1, NULL, 'Funeral architecture', 1, '2026-03-24 23:00:36', '2026-03-26 14:39:10', 'Omeka\\Entity\\Item'),
(15, 1, 9, 1, NULL, 'Egyptian Mausoleum', 1, '2026-03-24 23:16:56', '2026-03-26 14:18:08', 'Omeka\\Entity\\Item'),
(16, 1, NULL, NULL, NULL, NULL, 1, '2026-03-24 23:16:56', '2026-03-24 23:16:56', 'Omeka\\Entity\\Media'),
(17, 1, 9, 1, NULL, 'Gothic Mausoleum', 1, '2026-03-25 11:51:16', '2026-03-26 14:18:26', 'Omeka\\Entity\\Item'),
(18, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 11:51:16', '2026-03-25 11:51:16', 'Omeka\\Entity\\Media'),
(19, 1, 9, 1, NULL, 'Moorish Mausoleum', 1, '2026-03-25 11:57:04', '2026-03-26 14:18:42', 'Omeka\\Entity\\Item'),
(20, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:00:53', '2026-03-25 12:00:53', 'Omeka\\Entity\\Media'),
(21, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:01:30', '2026-03-25 12:01:30', 'Omeka\\Entity\\Media'),
(22, 1, NULL, 1, NULL, 'Historical figures', 1, '2026-03-25 12:09:40', '2026-03-26 14:40:11', 'Omeka\\Entity\\Item'),
(23, 1, 94, 1, NULL, 'Salvador Allende', 1, '2026-03-25 12:31:07', '2026-03-30 14:20:29', 'Omeka\\Entity\\Item'),
(24, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:31:07', '2026-03-25 12:31:07', 'Omeka\\Entity\\Media'),
(25, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:31:07', '2026-03-25 12:31:07', 'Omeka\\Entity\\Media'),
(26, 1, 94, 1, NULL, 'Andrés Bello', 1, '2026-03-25 12:37:50', '2026-03-26 13:56:13', 'Omeka\\Entity\\Item'),
(27, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:37:50', '2026-03-25 12:37:50', 'Omeka\\Entity\\Media'),
(28, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:37:51', '2026-03-25 12:37:51', 'Omeka\\Entity\\Media'),
(29, 1, 94, 1, NULL, 'Manuel Rodríguez', 1, '2026-03-25 12:47:41', '2026-03-30 14:20:58', 'Omeka\\Entity\\Item'),
(30, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 12:47:41', '2026-03-25 12:47:41', 'Omeka\\Entity\\Media'),
(32, 1, NULL, 1, NULL, 'Italian Mausoleum', 1, '2026-03-25 15:39:32', '2026-03-30 14:08:45', 'Omeka\\Entity\\Item'),
(33, 1, 9, 1, NULL, 'Capilla Verde', 1, '2026-03-25 15:42:51', '2026-03-26 14:22:23', 'Omeka\\Entity\\Item'),
(34, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 15:42:51', '2026-03-25 15:42:51', 'Omeka\\Entity\\Media'),
(35, 1, NULL, 1, NULL, 'Places of remembrance', 1, '2026-03-25 16:04:03', '2026-03-26 14:42:21', 'Omeka\\Entity\\Item'),
(36, 1, 9, 1, NULL, 'Patio Histórico', 1, '2026-03-25 16:09:41', '2026-03-26 14:32:08', 'Omeka\\Entity\\Item'),
(37, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 16:09:41', '2026-03-25 16:09:41', 'Omeka\\Entity\\Media'),
(38, 1, 9, 1, NULL, 'Patio de Disidentes', 1, '2026-03-25 16:21:04', '2026-03-26 14:30:36', 'Omeka\\Entity\\Item'),
(39, 1, NULL, NULL, NULL, NULL, 1, '2026-03-25 16:21:04', '2026-03-25 16:21:04', 'Omeka\\Entity\\Media'),
(40, 1, NULL, 1, NULL, 'Political tour', 1, '2026-03-25 16:39:04', '2026-03-26 14:44:42', 'Omeka\\Entity\\Item'),
(41, 1, NULL, 1, NULL, 'Artistic tour', 1, '2026-03-25 16:41:48', '2026-03-26 14:55:53', 'Omeka\\Entity\\Item'),
(42, 1, NULL, 1, NULL, 'Architectural tour', 1, '2026-03-25 16:46:17', '2026-03-26 14:57:55', 'Omeka\\Entity\\Item'),
(43, 1, NULL, 1, NULL, 'Historical figures', 1, '2026-03-25 16:49:57', '2026-03-26 13:52:06', 'Omeka\\Entity\\ItemSet'),
(44, 1, NULL, 1, NULL, 'Funeral Architecture', 1, '2026-03-26 14:00:06', '2026-03-26 14:00:06', 'Omeka\\Entity\\ItemSet'),
(45, 1, NULL, 1, NULL, 'Places of remembrance', 1, '2026-03-26 14:25:26', '2026-03-26 14:25:26', 'Omeka\\Entity\\ItemSet'),
(46, 1, NULL, 1, NULL, 'Themed tours', 1, '2026-03-26 14:33:35', '2026-03-26 14:33:35', 'Omeka\\Entity\\ItemSet'),
(47, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:08:45', '2026-03-30 14:08:45', 'Omeka\\Entity\\Media'),
(48, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:08:46', '2026-03-30 14:08:46', 'Omeka\\Entity\\Media'),
(49, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:12:33', '2026-03-30 14:12:33', 'Omeka\\Entity\\Media'),
(50, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:12:34', '2026-03-30 14:12:34', 'Omeka\\Entity\\Media'),
(51, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:12:34', '2026-03-30 14:12:34', 'Omeka\\Entity\\Media'),
(52, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:19:20', '2026-03-30 14:19:20', 'Omeka\\Entity\\Media'),
(54, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:20:29', '2026-03-30 14:20:29', 'Omeka\\Entity\\Media'),
(55, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:20:58', '2026-03-30 14:20:58', 'Omeka\\Entity\\Media'),
(56, 1, NULL, NULL, NULL, NULL, 1, '2026-03-30 14:56:33', '2026-03-30 14:56:33', 'Omeka\\Entity\\Media');

-- --------------------------------------------------------

--
-- Struttura della tabella `resource_class`
--

CREATE TABLE `resource_class` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `vocabulary_id` int NOT NULL,
  `local_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `resource_class`
--

INSERT INTO `resource_class` (`id`, `owner_id`, `vocabulary_id`, `local_name`, `label`, `comment`) VALUES
(1, NULL, 1, 'Agent', 'Agent', 'A resource that acts or has the power to act.'),
(2, NULL, 1, 'AgentClass', 'Agent Class', 'A group of agents.'),
(3, NULL, 1, 'BibliographicResource', 'Bibliographic Resource', 'A book, article, or other documentary resource.'),
(4, NULL, 1, 'FileFormat', 'File Format', 'A digital resource format.'),
(5, NULL, 1, 'Frequency', 'Frequency', 'A rate at which something recurs.'),
(6, NULL, 1, 'Jurisdiction', 'Jurisdiction', 'The extent or range of judicial, law enforcement, or other authority.'),
(7, NULL, 1, 'LicenseDocument', 'License Document', 'A legal document giving official permission to do something with a Resource.'),
(8, NULL, 1, 'LinguisticSystem', 'Linguistic System', 'A system of signs, symbols, sounds, gestures, or rules used in communication.'),
(9, NULL, 1, 'Location', 'Location', 'A spatial region or named place.'),
(10, NULL, 1, 'LocationPeriodOrJurisdiction', 'Location, Period, or Jurisdiction', 'A location, period of time, or jurisdiction.'),
(11, NULL, 1, 'MediaType', 'Media Type', 'A file format or physical medium.'),
(12, NULL, 1, 'MediaTypeOrExtent', 'Media Type or Extent', 'A media type or extent.'),
(13, NULL, 1, 'MethodOfInstruction', 'Method of Instruction', 'A process that is used to engender knowledge, attitudes, and skills.'),
(14, NULL, 1, 'MethodOfAccrual', 'Method of Accrual', 'A method by which resources are added to a collection.'),
(15, NULL, 1, 'PeriodOfTime', 'Period of Time', 'An interval of time that is named or defined by its start and end dates.'),
(16, NULL, 1, 'PhysicalMedium', 'Physical Medium', 'A physical material or carrier.'),
(17, NULL, 1, 'PhysicalResource', 'Physical Resource', 'A material thing.'),
(18, NULL, 1, 'Policy', 'Policy', 'A plan or course of action by an authority, intended to influence and determine decisions, actions, and other matters.'),
(19, NULL, 1, 'ProvenanceStatement', 'Provenance Statement', 'A statement of any changes in ownership and custody of a resource since its creation that are significant for its authenticity, integrity, and interpretation.'),
(20, NULL, 1, 'RightsStatement', 'Rights Statement', 'A statement about the intellectual property rights (IPR) held in or over a Resource, a legal document giving official permission to do something with a resource, or a statement about access rights.'),
(21, NULL, 1, 'SizeOrDuration', 'Size or Duration', 'A dimension or extent, or a time taken to play or execute.'),
(22, NULL, 1, 'Standard', 'Standard', 'A basis for comparison; a reference point against which other things can be evaluated.'),
(23, NULL, 2, 'Collection', 'Collection', 'An aggregation of resources.'),
(24, NULL, 2, 'Dataset', 'Dataset', 'Data encoded in a defined structure.'),
(25, NULL, 2, 'Event', 'Event', 'A non-persistent, time-based occurrence.'),
(26, NULL, 2, 'Image', 'Image', 'A visual representation other than text.'),
(27, NULL, 2, 'InteractiveResource', 'Interactive Resource', 'A resource requiring interaction from the user to be understood, executed, or experienced.'),
(28, NULL, 2, 'Service', 'Service', 'A system that provides one or more functions.'),
(29, NULL, 2, 'Software', 'Software', 'A computer program in source or compiled form.'),
(30, NULL, 2, 'Sound', 'Sound', 'A resource primarily intended to be heard.'),
(31, NULL, 2, 'Text', 'Text', 'A resource consisting primarily of words for reading.'),
(32, NULL, 2, 'PhysicalObject', 'Physical Object', 'An inanimate, three-dimensional object or substance.'),
(33, NULL, 2, 'StillImage', 'Still Image', 'A static visual representation.'),
(34, NULL, 2, 'MovingImage', 'Moving Image', 'A series of visual representations imparting an impression of motion when shown in succession.'),
(35, NULL, 3, 'AcademicArticle', 'Academic Article', 'A scholarly academic article, typically published in a journal.'),
(36, NULL, 3, 'Article', 'Article', 'A written composition in prose, usually nonfiction, on a specific topic, forming an independent part of a book or other publication, as a newspaper or magazine.'),
(37, NULL, 3, 'AudioDocument', 'audio document', 'An audio document; aka record.'),
(38, NULL, 3, 'AudioVisualDocument', 'audio-visual document', 'An audio-visual document; film, video, and so forth.'),
(39, NULL, 3, 'Bill', 'Bill', 'Draft legislation presented for discussion to a legal body.'),
(40, NULL, 3, 'Book', 'Book', 'A written or printed work of fiction or nonfiction, usually on sheets of paper fastened or bound together within covers.'),
(41, NULL, 3, 'BookSection', 'Book Section', 'A section of a book.'),
(42, NULL, 3, 'Brief', 'Brief', 'A written argument submitted to a court.'),
(43, NULL, 3, 'Chapter', 'Chapter', 'A chapter of a book.'),
(44, NULL, 3, 'Code', 'Code', 'A collection of statutes.'),
(45, NULL, 3, 'CollectedDocument', 'Collected Document', 'A document that simultaneously contains other documents.'),
(46, NULL, 3, 'Collection', 'Collection', 'A collection of Documents or Collections'),
(47, NULL, 3, 'Conference', 'Conference', 'A meeting for consultation or discussion.'),
(48, NULL, 3, 'CourtReporter', 'Court Reporter', 'A collection of legal cases.'),
(49, NULL, 3, 'Document', 'Document', 'A document (noun) is a bounded physical representation of body of information designed with the capacity (and usually intent) to communicate. A document may manifest symbolic, diagrammatic or sensory-representational information.'),
(50, NULL, 3, 'DocumentPart', 'document part', 'a distinct part of a larger document or collected document.'),
(51, NULL, 3, 'DocumentStatus', 'Document Status', 'The status of the publication of a document.'),
(52, NULL, 3, 'EditedBook', 'Edited Book', 'An edited book.'),
(53, NULL, 3, 'Email', 'EMail', 'A written communication addressed to a person or organization and transmitted electronically.'),
(54, NULL, 3, 'Event', 'Event', NULL),
(55, NULL, 3, 'Excerpt', 'Excerpt', 'A passage selected from a larger work.'),
(56, NULL, 3, 'Film', 'Film', 'aka movie.'),
(57, NULL, 3, 'Hearing', 'Hearing', 'An instance or a session in which testimony and arguments are presented, esp. before an official, as a judge in a lawsuit.'),
(58, NULL, 3, 'Image', 'Image', 'A document that presents visual or diagrammatic information.'),
(59, NULL, 3, 'Interview', 'Interview', 'A formalized discussion between two or more people.'),
(60, NULL, 3, 'Issue', 'Issue', 'something that is printed or published and distributed, esp. a given number of a periodical'),
(61, NULL, 3, 'Journal', 'Journal', 'A periodical of scholarly journal Articles.'),
(62, NULL, 3, 'LegalCaseDocument', 'Legal Case Document', 'A document accompanying a legal case.'),
(63, NULL, 3, 'LegalDecision', 'Decision', 'A document containing an authoritative determination (as a decree or judgment) made after consideration of facts or law.'),
(64, NULL, 3, 'LegalDocument', 'Legal Document', 'A legal document; for example, a court decision, a brief, and so forth.'),
(65, NULL, 3, 'Legislation', 'Legislation', 'A legal document proposing or enacting a law or a group of laws.'),
(66, NULL, 3, 'Letter', 'Letter', 'A written or printed communication addressed to a person or organization and usually transmitted by mail.'),
(67, NULL, 3, 'Magazine', 'Magazine', 'A periodical of magazine Articles. A magazine is a publication that is issued periodically, usually bound in a paper cover, and typically contains essays, stories, poems, etc., by many writers, and often photographs and drawings, frequently specializing in a particular subject or area, as hobbies, news, or sports.'),
(68, NULL, 3, 'Manual', 'Manual', 'A small reference book, especially one giving instructions.'),
(69, NULL, 3, 'Manuscript', 'Manuscript', 'An unpublished Document, which may also be submitted to a publisher for publication.'),
(70, NULL, 3, 'Map', 'Map', 'A graphical depiction of geographic features.'),
(71, NULL, 3, 'MultiVolumeBook', 'Multivolume Book', 'A loose, thematic, collection of Documents, often Books.'),
(72, NULL, 3, 'Newspaper', 'Newspaper', 'A periodical of documents, usually issued daily or weekly, containing current news, editorials, feature articles, and usually advertising.'),
(73, NULL, 3, 'Note', 'Note', 'Notes or annotations about a resource.'),
(74, NULL, 3, 'Patent', 'Patent', 'A document describing the exclusive right granted by a government to an inventor to manufacture, use, or sell an invention for a certain number of years.'),
(75, NULL, 3, 'Performance', 'Performance', 'A public performance.'),
(76, NULL, 3, 'Periodical', 'Periodical', 'A group of related documents issued at regular intervals.'),
(77, NULL, 3, 'PersonalCommunication', 'Personal Communication', 'A communication between an agent and one or more specific recipients.'),
(78, NULL, 3, 'PersonalCommunicationDocument', 'Personal Communication Document', 'A personal communication manifested in some document.'),
(79, NULL, 3, 'Proceedings', 'Proceedings', 'A compilation of documents published from an event, such as a conference.'),
(80, NULL, 3, 'Quote', 'Quote', 'An excerpted collection of words.'),
(81, NULL, 3, 'ReferenceSource', 'Reference Source', 'A document that presents authoritative reference information, such as a dictionary or encylopedia .'),
(82, NULL, 3, 'Report', 'Report', 'A document describing an account or statement describing in detail an event, situation, or the like, usually as the result of observation, inquiry, etc..'),
(83, NULL, 3, 'Series', 'Series', 'A loose, thematic, collection of Documents, often Books.'),
(84, NULL, 3, 'Slide', 'Slide', 'A slide in a slideshow'),
(85, NULL, 3, 'Slideshow', 'Slideshow', 'A presentation of a series of slides, usually presented in front of an audience with written text and images.'),
(86, NULL, 3, 'Standard', 'Standard', 'A document describing a standard'),
(87, NULL, 3, 'Statute', 'Statute', 'A bill enacted into law.'),
(88, NULL, 3, 'Thesis', 'Thesis', 'A document created to summarize research findings associated with the completion of an academic degree.'),
(89, NULL, 3, 'ThesisDegree', 'Thesis degree', 'The academic degree of a Thesis'),
(90, NULL, 3, 'Webpage', 'Webpage', 'A web page is an online document available (at least initially) on the world wide web. A web page is written first and foremost to appear on the web, as distinct from other online resources such as books, manuscripts or audio documents which use the web primarily as a distribution mechanism alongside other more traditional methods such as print.'),
(91, NULL, 3, 'Website', 'Website', 'A group of Webpages accessible on the Web.'),
(92, NULL, 3, 'Workshop', 'Workshop', 'A seminar, discussion group, or the like, that emphasizes zxchange of ideas and the demonstration and application of techniques, skills, etc.'),
(93, NULL, 4, 'LabelProperty', 'Label Property', 'A foaf:LabelProperty is any RDF property with texual values that serve as labels.'),
(94, NULL, 4, 'Person', 'Person', 'A person.'),
(95, NULL, 4, 'Document', 'Document', 'A document.'),
(96, NULL, 4, 'Organization', 'Organization', 'An organization.'),
(97, NULL, 4, 'Group', 'Group', 'A class of Agents.'),
(98, NULL, 4, 'Agent', 'Agent', 'An agent (eg. person, group, software or physical artifact).'),
(99, NULL, 4, 'Project', 'Project', 'A project (a collective endeavour of some kind).'),
(100, NULL, 4, 'Image', 'Image', 'An image.'),
(101, NULL, 4, 'PersonalProfileDocument', 'PersonalProfileDocument', 'A personal profile RDF document.'),
(102, NULL, 4, 'OnlineAccount', 'Online Account', 'An online account.'),
(103, NULL, 4, 'OnlineGamingAccount', 'Online Gaming Account', 'An online gaming account.'),
(104, NULL, 4, 'OnlineEcommerceAccount', 'Online E-commerce Account', 'An online e-commerce account.'),
(105, NULL, 4, 'OnlineChatAccount', 'Online Chat Account', 'An online chat account.');

-- --------------------------------------------------------

--
-- Struttura della tabella `resource_template`
--

CREATE TABLE `resource_template` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `resource_class_id` int DEFAULT NULL,
  `title_property_id` int DEFAULT NULL,
  `description_property_id` int DEFAULT NULL,
  `label` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `resource_template`
--

INSERT INTO `resource_template` (`id`, `owner_id`, `resource_class_id`, `title_property_id`, `description_property_id`, `label`) VALUES
(1, NULL, NULL, NULL, NULL, 'Base Resource');

-- --------------------------------------------------------

--
-- Struttura della tabella `resource_template_property`
--

CREATE TABLE `resource_template_property` (
  `id` int NOT NULL,
  `resource_template_id` int NOT NULL,
  `property_id` int NOT NULL,
  `alternate_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alternate_comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `position` int DEFAULT NULL,
  `data_type` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '(DC2Type:json_array)',
  `is_required` tinyint(1) NOT NULL,
  `is_private` tinyint(1) NOT NULL,
  `default_lang` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `resource_template_property`
--

INSERT INTO `resource_template_property` (`id`, `resource_template_id`, `property_id`, `alternate_label`, `alternate_comment`, `position`, `data_type`, `is_required`, `is_private`, `default_lang`) VALUES
(1, 1, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(2, 1, 15, NULL, NULL, 2, NULL, 0, 0, NULL),
(3, 1, 8, NULL, NULL, 3, NULL, 0, 0, NULL),
(4, 1, 2, NULL, NULL, 4, NULL, 0, 0, NULL),
(5, 1, 7, NULL, NULL, 5, NULL, 0, 0, NULL),
(6, 1, 4, NULL, NULL, 6, NULL, 0, 0, NULL),
(7, 1, 9, NULL, NULL, 7, NULL, 0, 0, NULL),
(8, 1, 12, NULL, NULL, 8, NULL, 0, 0, NULL),
(9, 1, 40, 'Place', NULL, 9, NULL, 0, 0, NULL),
(10, 1, 5, NULL, NULL, 10, NULL, 0, 0, NULL),
(11, 1, 17, NULL, NULL, 11, NULL, 0, 0, NULL),
(12, 1, 6, NULL, NULL, 12, NULL, 0, 0, NULL),
(13, 1, 25, NULL, NULL, 13, NULL, 0, 0, NULL),
(14, 1, 10, NULL, NULL, 14, NULL, 0, 0, NULL),
(15, 1, 13, NULL, NULL, 15, NULL, 0, 0, NULL),
(16, 1, 29, NULL, NULL, 16, NULL, 0, 0, NULL),
(17, 1, 30, NULL, NULL, 17, NULL, 0, 0, NULL),
(18, 1, 50, NULL, NULL, 18, NULL, 0, 0, NULL),
(19, 1, 3, NULL, NULL, 19, NULL, 0, 0, NULL),
(20, 1, 41, NULL, NULL, 20, NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `session`
--

CREATE TABLE `session` (
  `id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` longblob NOT NULL,
  `modified` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `session`
--

INSERT INTO `session` (`id`, `data`, `modified`) VALUES
('dg1cqgtev6km76l4kc0sm8m3k0', 0x5f5f4c616d696e61737c613a383a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313737343838323539352e3432383635343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223675696c6b7238616572313138686e666a756d76336f36743837223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313737343133313439303b7d733a34343a224c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313737343932353737383b7d733a34313a224c616d696e61735f56616c696461746f725f437372665f73616c745f73697465666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313737343333313437313b7d733a33323a224c616d696e61735f56616c696461746f725f437372665f73616c745f63737266223b613a313a7b733a363a22455850495245223b693a313737343932353737383b7d733a33373a224c616d696e61735f56616c696461746f725f437372665f73616c745f666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313737343333313735383b7d733a35303a224c616d696e61735f56616c696461746f725f437372665f73616c745f736974657265736f7572636573666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313737343333313437353b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223134356236323065616533623062393037323530386561343639616331393631223b733a33323a223263646262386361626464646230643231613231646262633364393664353538223b7d733a343a2268617368223b733a36353a2232636462623863616264646462306432316132316462626333643936643535382d3134356236323065616533623062393037323530386561343639616331393631223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f417574687c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a313a7b733a373a2273746f72616765223b693a313b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d72656469726563745f75726c7c4e3b4c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a33313a7b733a33323a226563396463633538636465643538646438376533356431363431633331356632223b733a33323a226338323963336633366630663832336562333138333638396338353833353236223b733a33323a226632353539616565386164366461633638306664373464636464313865666337223b733a33323a223636383262313739643637386666393936356462663532623035353032383132223b733a33323a223032386536663433326462616165663465393065373263613561396234663834223b733a33323a223431666231363864343662383732633730653662383165313133313439623837223b733a33323a226563373033383533393765346233353766373030656535633334666337623631223b733a33323a223737383137633465303032643839313361643636393235616363623763393562223b733a33323a223231363133316432396264306438646262386666303731323061633334356531223b733a33323a223830313435616138636464343037616166653236303632363439373563626630223b733a33323a223862383633366130313431303039636364663439363832356239613637326663223b733a33323a223230336262343064386635663934303961383662316263356635626531306332223b733a33323a223163386266633432643239396162636637666162653764303164643765666237223b733a33323a223931623962366136643937623436616362636138373132333136333465386232223b733a33323a223463633333393261663339666533623462313632346637643636343335346531223b733a33323a223831326435323362383461626236383336383932613034613261653138343166223b733a33323a223964343937373537343236346436373931616165333561643462633765633733223b733a33323a226265383062643164393165643864323537613362396566316537333763366438223b733a33323a226238613036616161613533656264373832613332333134633535343436396332223b733a33323a223061636630626434643434343233313036303635623963363834623062353661223b733a33323a223332306434313065363164303730613836333562663030316137363535636266223b733a33323a226163326238306566346438313236343965663434363534343836306539303431223b733a33323a223030306336373361336461316239303935633533353064653332396430376465223b733a33323a226439663263326365653565346166373965376334633236613031616538656165223b733a33323a223162353962363333313633633362316366363532316438366131383866633562223b733a33323a223630333662653233343439626162323963623539363238356635643265343731223b733a33323a223362663965643933383738306266323262383333326165363130383039623336223b733a33323a223230623430393331356336323764633930353534666630316438636336383634223b733a33323a223662623636636234383438373137333939303536303637363164346638336335223b733a33323a226164306235303939306635643636666266636564663735303330373132616633223b733a33323a223734356338313833336236656630343930326232336238313139323538356363223b733a33323a223962393934626339363434623832666634616465303835613561336435396137223b733a33323a226363303030663961663434633862343437633866653034383335393663626332223b733a33323a226230356565613636663462653662326639386236666666653161663336323836223b733a33323a223030636236353535643661343238666433393836623530656662306266646137223b733a33323a223761353831356235613938633462636661343432316439636233643164306134223b733a33323a223639626430316539323837643261643133623563376564363333393237316464223b733a33323a226666336566363330373335383335393638396139313234336262316530326264223b733a33323a223261306161303539386337363532363662373736383664303031643137326633223b733a33323a226338396538323738313933373537326431656136663638383533313161333432223b733a33323a226237656131616339363563376434636237323034643261623265383134376366223b733a33323a223866366230363937636561356336643262323133313433616236666330323334223b733a33323a226339616562643932373935636632393734663132363664616464386463663163223b733a33323a226265373964653365353236613137363933336633653930376362623563383334223b733a33323a223136616135613634613531306437653462336231643363303530306633626439223b733a33323a223332626530313661316539643232616265366463353733643630623461323735223b733a33323a223233343734373537346662306439383361396337383565366337663737636263223b733a33323a223437616535323162313865386165623832373836636263313063343931643430223b733a33323a226234323439633839636439643730636131653134623636303630313961383362223b733a33323a223133393530396437363462363533626635386564636436386163653964623537223b733a33323a223236323465383363353361323061666161306132313930363261643036323735223b733a33323a226435363065336562363332323230363361343433646533303937646566623962223b733a33323a223030653461613034303238316236363136333939366534633166656435366633223b733a33323a223861393635363664363531366134633766383862366464663139303236363064223b733a33323a223763353563633732646534346538323635636266366134346265393235343464223b733a33323a223434373963666430343434633265303232623263336237306132353932343139223b733a33323a223263663462623032656435323835376533643230623963363065323866306165223b733a33323a223764353234323366646333623763643062376634303161646133323562623639223b733a33323a226334616337656431343738313965643438653438656337353438613332363934223b733a33323a223335643365326266623635373566643162633563313935613939653937616138223b733a33323a223039643530343966333030333333376234366436623662383264373931613539223b733a33323a226463363963366238333737623533663637653264363032303562333331633637223b7d733a343a2268617368223b733a36353a2264633639633662383337376235336636376532643630323035623333316336372d3039643530343966333030333333376234366436623662383264373931613539223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f73697465666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a343a7b733a33323a226564313639373465643366623539656365326536613063656534646361356539223b733a33323a226664666239326365303433643862313231336631393065636639656431643835223b733a33323a223366363663353234346130613338643362636431613764633839663331626466223b733a33323a223035393161653065346131333263306365393035623237636662383766616665223b733a33323a223865653736333065323836336130653164316230333132333138383939643637223b733a33323a226636316363393164633830306538313566333130373336666633336431363463223b733a33323a226434636237373738663832316539383336323330326538323430663937653263223b733a33323a226532646564663538313763316365353062306332383931646161366232373832223b7d733a343a2268617368223b733a36353a2265326465646635383137633163653530623063323839316461613662323738322d6434636237373738663832316539383336323330326538323430663937653263223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a31313a7b733a33323a223164613335646563613363346566333561366534313338376463376666323366223b733a33323a223234613962633032353765396663646265336165386664343233313734306237223b733a33323a223835353135383834313566616465633231633264636163613864316139666335223b733a33323a226538613033373065663361383666323166643532643935393135646130353338223b733a33323a223339343635663964623436616462313439326633613166383865333135626133223b733a33323a226333663334663032623137343632663862613562333839326339313539303834223b733a33323a223034356361653466636631373439346439303134383663313766343137306438223b733a33323a223032383039323363313532623035333331633061323961613861333134623139223b733a33323a226532396337656636663365663532356261353965373336346138663565626138223b733a33323a226364653861376462333065643161616162386137626533623361396466373136223b733a33323a223038303537356263346365333937383266356439383435633235323533646362223b733a33323a226639666261313266313261343464353537373737616339653433356361323632223b733a33323a226366326666363763643335636438666130623631323965626262303762356264223b733a33323a223539643036613761356661383532656563386461376637623935633037356639223b733a33323a223534623331333634356639633133346463336464306166396234653437336433223b733a33323a223563646566326530303930393336613961613261393162323464313832396239223b733a33323a226136626665306266303764353534333063343661386663373561306534393536223b733a33323a223839306265356661333961626133613763333630316361663330633133653764223b733a33323a226430383766646262633334336134353330666432393332653737363162636231223b733a33323a226336323566643834646330653261663562343338356161346238636131353739223b733a33323a223139373438323039346265623137373865316332633731366266623532646363223b733a33323a226130363661386637363934323965663037643865303763626232356337646538223b7d733a343a2268617368223b733a36353a2261303636613866373639343239656630376438653037636262323563376465382d3139373438323039346265623137373865316332633731366266623532646363223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a353a7b733a33323a223938336165613631333633663833613931646632353234666431346337653134223b733a33323a223465623263303564363763396465336537353364626465626234373732313061223b733a33323a223336323636333861383134326534386139356166393862636130393466336166223b733a33323a226166376264356435323463643830386161396239656165333462353561633262223b733a33323a223533366534623631323466373866373735346339623639343434336135623838223b733a33323a223731633932646430346435363731636530383235343435313138336239346461223b733a33323a223962613437663639353439356334346138313037346361363530616161396339223b733a33323a226335383039303265383832326162316363633464343330376239633030333539223b733a33323a223634326532613365613637343734376437663735393936623831333331666330223b733a33323a223034393536386564313934643437393637316562373233393131623766643938223b7d733a343a2268617368223b733a36353a2230343935363865643139346434373936373165623732333931316237666439382d3634326532613365613637343734376437663735393936623831333331666330223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f736974657265736f7572636573666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a323a7b733a33323a223336613661666566616136306437393135666232323163353837643931383962223b733a33323a223831306338636330303462303736356533303338383230613234616432666137223b733a33323a223463393263616364636533343835313933666264633161616234316461356531223b733a33323a223966396433383764343764313734323630646435346466336262666132663339223b7d733a343a2268617368223b733a36353a2239663964333837643437643137343236306464353464663362626661326633392d3463393263616364636533343835313933666264633161616234316461356531223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1774882595);

-- --------------------------------------------------------

--
-- Struttura della tabella `setting`
--

CREATE TABLE `setting` (
  `id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json_array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `setting`
--

INSERT INTO `setting` (`id`, `value`) VALUES
('administrator_email', '\"vincenzo.milordo@edu.unito.it\"'),
('extension_whitelist', '[\"aac\",\"aif\",\"aiff\",\"asf\",\"asx\",\"avi\",\"bmp\",\"c\",\"cc\",\"class\",\"css\",\"divx\",\"doc\",\"docx\",\"exe\",\"gif\",\"gz\",\"gzip\",\"h\",\"ico\",\"j2k\",\"jp2\",\"jpe\",\"jpeg\",\"jpg\",\"m4a\",\"m4v\",\"mdb\",\"mid\",\"midi\",\"mov\",\"mp2\",\"mp3\",\"mp4\",\"mpa\",\"mpe\",\"mpeg\",\"mpg\",\"mpp\",\"odb\",\"odc\",\"odf\",\"odg\",\"odp\",\"ods\",\"odt\",\"ogg\",\"opus\",\"pdf\",\"png\",\"pot\",\"pps\",\"ppt\",\"pptx\",\"qt\",\"ra\",\"ram\",\"rtf\",\"rtx\",\"swf\",\"tar\",\"tif\",\"tiff\",\"txt\",\"wav\",\"wax\",\"webm\",\"webp\",\"wma\",\"wmv\",\"wmx\",\"wri\",\"xla\",\"xls\",\"xlsx\",\"xlt\",\"xlw\",\"zip\"]'),
('installation_title', '\"Progetto_cimitero \"'),
('locale', '\"it\"'),
('media_type_whitelist', '[\"application\\/msword\",\"application\\/ogg\",\"application\\/pdf\",\"application\\/rtf\",\"application\\/vnd.ms-access\",\"application\\/vnd.ms-excel\",\"application\\/vnd.ms-powerpoint\",\"application\\/vnd.ms-project\",\"application\\/vnd.ms-write\",\"application\\/vnd.oasis.opendocument.chart\",\"application\\/vnd.oasis.opendocument.database\",\"application\\/vnd.oasis.opendocument.formula\",\"application\\/vnd.oasis.opendocument.graphics\",\"application\\/vnd.oasis.opendocument.presentation\",\"application\\/vnd.oasis.opendocument.spreadsheet\",\"application\\/vnd.oasis.opendocument.text\",\"application\\/vnd.openxmlformats-officedocument.wordprocessingml.document\",\"application\\/vnd.openxmlformats-officedocument.presentationml.presentation\",\"application\\/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"application\\/x-gzip\",\"application\\/x-ms-wmp\",\"application\\/x-msdownload\",\"application\\/x-shockwave-flash\",\"application\\/x-tar\",\"application\\/zip\",\"audio\\/midi\",\"audio\\/mp4\",\"audio\\/mpeg\",\"audio\\/ogg\",\"audio\\/x-aac\",\"audio\\/x-aiff\",\"audio\\/x-ms-wma\",\"audio\\/x-ms-wax\",\"audio\\/x-realaudio\",\"audio\\/x-wav\",\"image\\/bmp\",\"image\\/gif\",\"image\\/jp2\",\"image\\/jpeg\",\"image\\/pjpeg\",\"image\\/png\",\"image\\/tiff\",\"image\\/webp\",\"image\\/x-icon\",\"text\\/css\",\"text\\/plain\",\"text\\/richtext\",\"video\\/divx\",\"video\\/mp4\",\"video\\/mpeg\",\"video\\/ogg\",\"video\\/quicktime\",\"video\\/webm\",\"video\\/x-ms-asf,\",\"video\\/x-msvideo\",\"video\\/x-ms-wmv\"]'),
('pagination_per_page', '25'),
('time_zone', '\"UTC\"'),
('use_htmlpurifier', '\"1\"'),
('version', '\"4.2.0\"'),
('version_notifications', '\"1\"');

-- --------------------------------------------------------

--
-- Struttura della tabella `site`
--

CREATE TABLE `site` (
  `id` int NOT NULL,
  `thumbnail_id` int DEFAULT NULL,
  `homepage_id` int DEFAULT NULL,
  `owner_id` int DEFAULT NULL,
  `slug` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `theme` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `navigation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json_array)',
  `item_pool` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json_array)',
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  `assign_new_items` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `site`
--

INSERT INTO `site` (`id`, `thumbnail_id`, `homepage_id`, `owner_id`, `slug`, `theme`, `title`, `summary`, `navigation`, `item_pool`, `created`, `modified`, `is_public`, `assign_new_items`) VALUES
(1, NULL, NULL, 1, 'TestSito', 'default', 'TestSito', 'prova creazione sito', '[{\"type\":\"browse\",\"data\":{\"label\":\"Sfoglia\",\"query\":\"\"},\"links\":[]}]', '[]', '2026-03-23 17:48:09', '2026-03-23 17:48:09', 1, 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `site_block_attachment`
--

CREATE TABLE `site_block_attachment` (
  `id` int NOT NULL,
  `block_id` int NOT NULL,
  `item_id` int DEFAULT NULL,
  `media_id` int DEFAULT NULL,
  `caption` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `site_item_set`
--

CREATE TABLE `site_item_set` (
  `id` int NOT NULL,
  `site_id` int NOT NULL,
  `item_set_id` int NOT NULL,
  `position` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `site_page`
--

CREATE TABLE `site_page` (
  `id` int NOT NULL,
  `site_id` int NOT NULL,
  `slug` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_public` tinyint(1) NOT NULL,
  `layout` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `layout_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '(DC2Type:json)',
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `site_page`
--

INSERT INTO `site_page` (`id`, `site_id`, `slug`, `title`, `is_public`, `layout`, `layout_data`, `created`, `modified`) VALUES
(1, 1, 'welcome', 'Benvenuto', 1, NULL, NULL, '2026-03-23 17:48:09', '2026-03-23 17:48:09');

-- --------------------------------------------------------

--
-- Struttura della tabella `site_page_block`
--

CREATE TABLE `site_page_block` (
  `id` int NOT NULL,
  `page_id` int NOT NULL,
  `layout` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json_array)',
  `layout_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '(DC2Type:json)',
  `position` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `site_page_block`
--

INSERT INTO `site_page_block` (`id`, `page_id`, `layout`, `data`, `layout_data`, `position`) VALUES
(1, 1, 'html', '{\"html\":\"    <p>Welcome to your new site. This is an example page.<\\/p>\\n    <ul>\\n        <li>This is a bullet list.<\\/li>\\n        <li>Second entry.<\\/li>\\n    <\\/ul>\\n    <p>Back to normal again.<\\/p>\\n    <ol>\\n        <li>This is an ordered list.<\\/li>\\n        <li>Second entry.<\\/li>\\n    <\\/ol>\\n    <p>Back to normal again.<\\/p>\\n    <blockquote>This is a blockquote.<\\/blockquote>\\n    <p>Back to normal again.<\\/p>\\n    <div><a href=\\\"#\\\">This text is a link, which currently points to nothing.<\\/a><\\/div>\\n    <p><strong>This text is bold, in a &lt;strong&gt; tag.<\\/strong><\\/p>\\n    <p><em>This text is italicized, in an &lt;em&gt; tag.<\\/em><\\/p>\\n    <p><u>This text is underlined, in a &lt;u&gt; tag.<\\/u><\\/p>\\n    <p><s>This text has a strikethrough, in a &lt;s&gt; tag.<\\/s><\\/p>\\n    <p>This text is <sub>subscript<\\/sub> and <sup>superscript<\\/sup> using &lt;sub&gt; and &lt;sup&gt;, which can be used for adding notes and citations.<\\/p>\\n    <hr \\/>\\n    <h1>This is an H1 title. It is bigger than the Page Title, which is rendered in H2.<\\/h1>\\n    <h2>This is an H2 header, the same size as the Page Title.<\\/h2>\\n    <h3>This is an H3 subheader.<\\/h3>\\n    <h4>This is an H4 subheader.<\\/h4>\\n    <h5>This is an H5 subheader.<\\/h5>\\n    <h6>This is an H6 subheader.<\\/h6>\"}', NULL, 1),
(2, 1, 'lineBreak', '{\"break_type\":\"opaque\"}', NULL, 2),
(3, 1, 'html', '{\"html\":\"    <h2 style=\\\"font-style:italic;\\\">This is the \\\"Italic Title\\\" block style.<\\/h2>\\n    <h3 style=\\\"color:#aaaaaa;font-style:italic;\\\">This is the \\\"Subtitle\\\" block style.<\\/h3>\\n    <div style=\\\"background:#eeeeee;border:1px solid #cccccc;padding:5px 10px;\\\">This is the \\\"Special Container\\\" block style.<\\/div>\\n    <p><span class=\\\"marker\\\">This is the \\\"Marker\\\" inline style. <\\/span><\\/p>\\n    <p><small>This text is inside a \\\"small\\\" inline style.<\\/small> This is normal text.<\\/p>\\n    <p><code>This is the \\\"Computer Code\\\" inline style.<\\/code><\\/p>\\n    <p><span dir=\\\"rtl\\\" lang=\\\"ar\\\" xml:lang=\\\"ar\\\">\\u0644\\u0643\\u0646 \\u0644\\u0627 \\u0628\\u062f \\u0623\\u0646 \\u0623\\u0648\\u0636\\u062d \\u0644\\u0643 \\u0623\\u0646 \\u0643\\u0644 \\u0647\\u0630\\u0647 \\u0627\\u0644\\u0623\\u0641\\u0643\\u0627\\u0631 \\u0627\\u0644\\u0645\\u063a\\u0644\\u0648\\u0637\\u0629 \\u062d\\u0648\\u0644 \\u0627\\u0633\\u062a\\u0646\\u0643\\u0627\\u0631 \\u0627\\u0644\\u0646\\u0634\\u0648\\u0629 \\u0648\\u062a\\u0645\\u062c\\u064a\\u062f \\u0627\\u0644\\u0623\\u0644\\u0645 \\u064a\\u0639\\u0631\\u0636 \\u0647\\u0630\\u0627 \\u0627\\u0644\\u0646\\u0635 \\u0645\\u0646 \\u0627\\u0644\\u064a\\u0645\\u064a\\u0646 \\u0625\\u0644\\u0649 \\u0627\\u0644\\u064a\\u0633\\u0627\\u0631.<\\/span><\\/p>\"}', NULL, 3);

-- --------------------------------------------------------

--
-- Struttura della tabella `site_permission`
--

CREATE TABLE `site_permission` (
  `id` int NOT NULL,
  `site_id` int NOT NULL,
  `user_id` int NOT NULL,
  `role` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `site_permission`
--

INSERT INTO `site_permission` (`id`, `site_id`, `user_id`, `role`) VALUES
(1, 1, 1, 'admin');

-- --------------------------------------------------------

--
-- Struttura della tabella `site_setting`
--

CREATE TABLE `site_setting` (
  `id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `site_id` int NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json_array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `password_hash` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `user`
--

INSERT INTO `user` (`id`, `email`, `name`, `created`, `modified`, `password_hash`, `role`, `is_active`) VALUES
(1, 'vincenzo.milordo@edu.unito.it', 'Vincenzo', '2026-03-21 10:18:09', '2026-03-21 10:18:09', '$2y$10$Lcrs8hPRQVYUVP8egR57Yul.283wURlsR40PpcqfeXei3ihL5I.Q.', 'global_admin', 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `user_setting`
--

CREATE TABLE `user_setting` (
  `id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json_array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `value`
--

CREATE TABLE `value` (
  `id` int NOT NULL,
  `resource_id` int NOT NULL,
  `property_id` int NOT NULL,
  `value_resource_id` int DEFAULT NULL,
  `value_annotation_id` int DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lang` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `uri` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_public` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `value`
--

INSERT INTO `value` (`id`, `resource_id`, `property_id`, `value_resource_id`, `value_annotation_id`, `type`, `lang`, `value`, `uri`, `is_public`) VALUES
(1, 1, 1, NULL, NULL, 'literal', '', 'Violeta Parra', NULL, 1),
(2, 1, 8, NULL, NULL, 'literal', '', 'Character', NULL, 1),
(3, 1, 4, NULL, NULL, 'literal', '', 'Violeta Parra is one of the most significant cultural figures of 20th-century Chile. A singer-songwriter, artist and folklorist, she is regarded as a central figure in Chilean culture. On the guided tour of the General Cemetery, she is listed among the notable figures and is marked on the map in section P102. Her presence helps to define the cemetery as a space of national memory and an open-air museum.\nLocation: P102, General Cemetery of Santiago.', NULL, 1),
(4, 6, 1, NULL, NULL, 'literal', '', 'Nazario Elguín\'s Mausoleum', NULL, 1),
(5, 6, 8, NULL, NULL, 'literal', '', 'Nazario Elguín\'s Mausoleum', NULL, 1),
(6, 6, 2, NULL, NULL, 'literal', '', 'Tebaldo Brugnoli', NULL, 1),
(7, 6, 7, NULL, NULL, 'literal', '', '1893', NULL, 1),
(8, 6, 4, NULL, NULL, 'literal', '', 'The Nazario Elguín Mausoleum is one of the most significant examples of exotic funerary architecture in the Cementerio General de Santiago. Designed in 1893 by the architect Tebaldo Brugnoli, it features one of the most daring examples of Mayan-Aztec style in the complex. The mausoleum incorporates symbolic elements such as the Aztec calendar and references to the figure of Coatlicue, expressing a strong stylistic freedom and rich iconography.\nIt represents a key example for interpreting the cemetery as a museum of architecture and a manifestation of the social dynamics of the era.\nLocation: P28.', NULL, 1),
(9, 9, 1, NULL, NULL, 'literal', '', 'Patio 29', NULL, 1),
(10, 9, 8, NULL, NULL, 'literal', '', 'Place of remembrance', NULL, 1),
(11, 9, 4, NULL, NULL, 'literal', '', 'Patio 29 is one of the most significant memorial sites in the Cementerio General de Santiago. It is known for housing the graves of disappeared detainees and victims of political executions during the Chilean dictatorship, and has become a symbol of collective memory and human rights violations.\nWithin the context of the digital project, it represents the historical and civic dimension of the cemetery, highlighting its role as a space of remembrance as well as a burial ground.\nLocation: 162.', NULL, 1),
(12, 1, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(13, 6, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(14, 9, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(15, 12, 1, NULL, NULL, 'literal', '', 'Map', NULL, 1),
(16, 12, 4, NULL, NULL, 'literal', '', 'The general map of the Cementerio General de Santiago organises the site’s main points of interest, including historical figures, mausoleums, sculptures and memorial sites. These points are identified using a coordinate system (P1, P2, etc.), which allows each element to be located within the space.\nIn the digital project, the map serves as the central hub connecting the items, enabling spatial and thematic navigation of the cemetery.', NULL, 1),
(17, 1, 13, 22, NULL, 'resource', NULL, NULL, NULL, 1),
(18, 14, 1, NULL, NULL, 'literal', '', 'Funeral architecture', NULL, 1),
(19, 14, 8, NULL, NULL, 'literal', '', 'Category', NULL, 1),
(21, 15, 1, NULL, NULL, 'literal', '', 'Egyptian Mausoleum', NULL, 1),
(22, 15, 8, NULL, NULL, 'literal', '', 'Mausoleum', NULL, 1),
(23, 15, 4, NULL, NULL, 'literal', '', 'The Egyptian Mausoleum at the Cementerio General de Santiago is one of the most striking examples of exotic influence in Chilean funerary architecture. Featuring iconographic elements from ancient Egypt, such as pyramidal forms and symbols associated with death and eternity, the mausoleum reflects an interest in ancient and distant cultures.\nThis type of architecture bears witness to the elite’s desire to express prestige and distinction through international symbolic models.\nLocation: Patio 37.', NULL, 1),
(24, 15, 13, 14, NULL, 'resource', NULL, NULL, NULL, 1),
(25, 15, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(26, 17, 1, NULL, NULL, 'literal', '', 'Gothic Mausoleum ', NULL, 1),
(27, 17, 8, NULL, NULL, 'literal', '', 'Mausoleum ', NULL, 1),
(28, 17, 4, NULL, NULL, 'literal', '', 'The Gothic Mausoleum is an example of funerary architecture inspired by the European Neo-Gothic style. Characterised by pointed arches, vertical ornamentation and symbolic references to Christian spirituality, this type of mausoleum reflects the influence of European culture on the construction of the Chilean elite’s identity.\nThe presence of these elements helps to transform the cemetery into a complex and multi-layered architectural space.\nLocation: Patio 27', NULL, 1),
(29, 17, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(30, 17, 13, 14, NULL, 'resource', NULL, NULL, NULL, 1),
(31, 19, 1, NULL, NULL, 'literal', '', 'Moorish Mausoleum ', NULL, 1),
(32, 19, 8, NULL, NULL, 'literal', '', 'Mausoleum ', NULL, 1),
(33, 19, 4, NULL, NULL, 'literal', '', 'The Moorish Mausoleum is one of the most distinctive examples of funerary architecture in the General Cemetery. Inspired by Islamic art, it features decorative elements such as horseshoe arches and intricate ornamental motifs.\nThis style bears witness to the cultural diversity and creative freedom evident in the design of the mausoleums, highlighting the cemetery as a space for architectural and symbolic experimentation.\nLocation: Patio 17.', NULL, 1),
(34, 19, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(35, 19, 13, 14, NULL, 'resource', NULL, NULL, NULL, 1),
(36, 22, 1, NULL, NULL, 'literal', '', 'Historical figures ', NULL, 1),
(37, 22, 8, NULL, NULL, 'literal', '', 'Category', NULL, 1),
(38, 22, 4, NULL, NULL, 'literal', '', 'The historical figures buried at the Cementerio General de Santiago include prominent figures from Chile’s political, cultural and social history. Among them are artists, intellectuals, political leaders and key figures in the nation’s history.\nWithin the digital project, this section enables users to organise and link the various figures buried in the cemetery, offering a thematic overview that complements the spatial view provided by the map.', NULL, 1),
(40, 23, 1, NULL, NULL, 'literal', '', 'Salvador Allende', NULL, 1),
(41, 23, 8, NULL, NULL, 'literal', '', 'Character ', NULL, 1),
(42, 23, 4, NULL, NULL, 'literal', '', 'Salvador Allende Gossens was a Chilean politician and President of the Republic of Chile from 1970 to 1973. A central figure in the country’s political history, he is known for his programme of social transformation and for the coup d’état that led to his death.\nHis presence in the Cementerio General makes him a key figure in Chile’s historical and political memory, placing him amongst the cemetery’s notable figures.\nLocation: Patio 50. ', NULL, 1),
(43, 23, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(44, 23, 13, 22, NULL, 'resource', NULL, NULL, NULL, 1),
(45, 23, 3, NULL, NULL, 'literal', '', 'Politics; Chilean history; remembrance', NULL, 1),
(46, 26, 1, NULL, NULL, 'literal', '', 'Andrés Bello', NULL, 1),
(47, 26, 8, NULL, NULL, 'literal', '', 'Character ', NULL, 1),
(48, 26, 4, NULL, NULL, 'literal', '', 'Andrés Bello was a Venezuelan-born Chilean intellectual, jurist and humanist, and a key figure in Chile’s cultural and institutional development during the 19th century. He is renowned for his contributions to language, law and education, as well as for founding the University of Chile.\nHis presence in the General Cemetery is a key element in interpreting the cemetery as a space of the country’s cultural and intellectual memory.\nLocation: P16.', NULL, 1),
(49, 26, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(50, 26, 13, 22, NULL, 'resource', NULL, NULL, NULL, 1),
(51, 26, 3, NULL, NULL, 'literal', '', 'Culture; law; education; history', NULL, 1),
(52, 29, 1, NULL, NULL, 'literal', '', 'Manuel Rodríguez', NULL, 1),
(53, 29, 8, NULL, NULL, 'literal', '', 'Character ', NULL, 1),
(54, 29, 4, NULL, NULL, 'literal', '', 'At the Cementerio General, his presence contributes to the site’s historical and patriotic significance, reinforcing the cemetery’s role as a place of national remembrance.\nLocation: 38.', NULL, 1),
(55, 29, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(56, 29, 13, 22, NULL, 'resource', NULL, NULL, NULL, 1),
(57, 29, 3, NULL, NULL, 'literal', '', 'Independence; history; national identity', NULL, 1),
(58, 32, 1, NULL, NULL, 'literal', '', 'Italian Mausoleum ', NULL, 1),
(59, 32, 8, NULL, NULL, 'literal', '', 'Mausoleum ', NULL, 1),
(60, 32, 4, NULL, NULL, 'literal', '', '\nThe Italian Mausoleum exemplifies the influence of European funerary architecture within the Cementerio General de Santiago. Characterised by classical elements and formal symmetry, it reflects the architectural styles imported from Italy and adopted by the Chilean elite between the 19th and 20th centuries.\nLocation: Patio 15.', NULL, 1),
(61, 32, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(62, 32, 13, 14, NULL, 'resource', NULL, NULL, NULL, 1),
(63, 33, 1, NULL, NULL, 'literal', '', ' Capilla Verde', NULL, 1),
(64, 33, 8, NULL, NULL, 'literal', '', 'Funerary structure', NULL, 1),
(65, 33, 4, NULL, NULL, 'literal', '', 'The Capilla Verde is one of the most recognisable architectural features of the General Cemetery. It serves as a ceremonial and symbolic space, contributing to the cemetery’s religious and ritual dimension.\nLocation: Courtyard 42.', NULL, 1),
(66, 33, 29, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(67, 33, 29, 14, NULL, 'resource', NULL, NULL, NULL, 1),
(68, 35, 1, NULL, NULL, 'literal', '', 'Places of remembrance ', NULL, 1),
(69, 35, 8, NULL, NULL, 'literal', '', 'Category', NULL, 1),
(70, 35, 4, NULL, NULL, 'literal', '', 'The memorial sites within the Cementerio General include areas linked to Chile’s political and social history, particularly the memory of the dictatorship and human rights violations. This section enables users to link and organize the cemetery’s significant sites from a historical and commemorative perspective.', NULL, 1),
(71, 36, 1, NULL, NULL, 'literal', '', ' Patio Histórico', NULL, 1),
(72, 36, 8, NULL, NULL, 'literal', '', 'Place of remembrance', NULL, 1),
(73, 36, 4, NULL, NULL, 'literal', '', 'The Patio Histórico is one of the oldest areas of the Cementerio General, characterised by the presence of historic graves and significant monuments. It is a key site for understanding the cemetery’s historical development.\nLocation: Patio 05.', NULL, 1),
(74, 36, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(75, 36, 13, 35, NULL, 'resource', NULL, NULL, NULL, 1),
(76, 9, 13, 35, NULL, 'resource', NULL, NULL, NULL, 1),
(77, 38, 1, NULL, NULL, 'literal', '', 'Patio de Disidentes', NULL, 1),
(78, 38, 8, NULL, NULL, 'literal', '', 'Place of remembrance', NULL, 1),
(79, 38, 4, NULL, NULL, 'literal', '', 'The Patio de Disidentes is a space set aside for people who do not belong to the Catholic faith, representing an important aspect of religious and cultural diversity within the cemetery.\nLocation: Patio 01.', NULL, 1),
(80, 40, 1, NULL, NULL, 'literal', '', 'Political tour', NULL, 1),
(81, 40, 8, NULL, NULL, 'literal', '', 'Thematic tour', NULL, 1),
(82, 40, 4, NULL, NULL, 'literal', '', 'The political tour of the Cementerio General explores places and figures linked to Chile’s political history, offering an interpretation of the cemetery as a space of national memory.\nThrough figures such as Salvador Allende and symbolic sites such as Patio 29, the tour highlights the cemetery’s role in preserving collective memory and representing the most significant moments in the country’s political history.', NULL, 1),
(83, 40, 13, 9, NULL, 'resource', NULL, NULL, NULL, 1),
(84, 40, 13, 23, NULL, 'resource', NULL, NULL, NULL, 1),
(85, 41, 1, NULL, NULL, 'literal', '', 'Artistic tour', NULL, 1),
(86, 41, 8, NULL, NULL, 'literal', '', 'Thematic tour', NULL, 1),
(87, 41, 4, NULL, NULL, 'literal', '', 'The Cementerio General’s artistic journey highlights figures and elements linked to cultural and artistic production.\nThrough figures such as Violeta Parra, the cemetery is interpreted not only as a place of burial, but also as a space for artistic and symbolic expression, capable of telling the cultural history of Chile.', NULL, 1),
(88, 41, 13, 1, NULL, 'resource', NULL, NULL, NULL, 1),
(89, 42, 1, NULL, NULL, 'literal', '', 'Architectural tour', NULL, 1),
(90, 42, 8, NULL, NULL, 'literal', '', 'Thematic tour', NULL, 1),
(91, 42, 4, NULL, NULL, 'literal', '', 'The architectural tour of the General Cemetery highlights the variety of styles and influences found in the site’s funerary architecture.\nThrough mausoleums and structures such as the Green Chapel, the tour demonstrates how the cemetery functions as an open-air museum, characterized by a rich cultural and architectural heritage.', NULL, 1),
(92, 42, 13, 19, NULL, 'resource', NULL, NULL, NULL, 1),
(93, 42, 13, 15, NULL, 'resource', NULL, NULL, NULL, 1),
(94, 42, 13, 17, NULL, 'resource', NULL, NULL, NULL, 1),
(95, 42, 13, 32, NULL, 'resource', NULL, NULL, NULL, 1),
(96, 42, 13, 6, NULL, 'resource', NULL, NULL, NULL, 1),
(97, 42, 13, 33, NULL, 'resource', NULL, NULL, NULL, 1),
(98, 43, 1, NULL, NULL, 'literal', '', 'Historical figures', NULL, 1),
(99, 43, 4, NULL, NULL, 'literal', '', 'A collection of historical and cultural figures.', NULL, 1),
(100, 44, 1, NULL, NULL, 'literal', '', 'Funeral Architecture', NULL, 1),
(101, 44, 4, NULL, NULL, 'literal', '', 'A collection of the architectural and funerary features of the cemetery, including mausoleums and other structures.', NULL, 1),
(102, 6, 13, 14, NULL, 'resource', NULL, NULL, NULL, 1),
(103, 45, 1, NULL, NULL, 'literal', '', 'Places of remembrance', NULL, 1),
(104, 45, 4, NULL, NULL, 'literal', '', ' A collection of sites linked to the historical and social heritage of the cemetery.', NULL, 1),
(105, 38, 13, 12, NULL, 'resource', NULL, NULL, NULL, 1),
(106, 38, 13, 35, NULL, 'resource', NULL, NULL, NULL, 1),
(107, 46, 1, NULL, NULL, 'literal', '', 'Themed tours', NULL, 1),
(108, 46, 4, NULL, NULL, 'literal', '', 'A collection of the interpretative trails created as part of the project.', NULL, 1),
(109, 14, 4, NULL, NULL, 'literal', '', 'The funerary architecture of the Cementerio General de Santiago encompasses a wide variety of styles, including European and exotic influences. Mausoleums, chapels and monuments reflect the social, cultural and symbolic dynamics of Chilean society between the 19th and 20th centuries, transforming the cemetery into an open-air museum.', NULL, 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `value_annotation`
--

CREATE TABLE `value_annotation` (
  `id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `vocabulary`
--

CREATE TABLE `vocabulary` (
  `id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `namespace_uri` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `vocabulary`
--

INSERT INTO `vocabulary` (`id`, `owner_id`, `namespace_uri`, `prefix`, `label`, `comment`) VALUES
(1, NULL, 'http://purl.org/dc/terms/', 'dcterms', 'Dublin Core', 'Basic resource metadata (DCMI Metadata Terms)'),
(2, NULL, 'http://purl.org/dc/dcmitype/', 'dctype', 'Dublin Core Type', 'Basic resource types (DCMI Type Vocabulary)'),
(3, NULL, 'http://purl.org/ontology/bibo/', 'bibo', 'Bibliographic Ontology', 'Bibliographic metadata (BIBO)'),
(4, NULL, 'http://xmlns.com/foaf/0.1/', 'foaf', 'Friend of a Friend', 'Relationships between people and organizations (FOAF)');

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `api_key`
--
ALTER TABLE `api_key`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_C912ED9D7E3C61F9` (`owner_id`);

--
-- Indici per le tabelle `asset`
--
ALTER TABLE `asset`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_2AF5A5C5CC5DB90` (`storage_id`),
  ADD KEY `IDX_2AF5A5C7E3C61F9` (`owner_id`);

--
-- Indici per le tabelle `fulltext_search`
--
ALTER TABLE `fulltext_search`
  ADD PRIMARY KEY (`id`,`resource`),
  ADD KEY `IDX_AA31FE4A7E3C61F9` (`owner_id`);
ALTER TABLE `fulltext_search` ADD FULLTEXT KEY `IDX_AA31FE4A2B36786B3B8BA7C7` (`title`,`text`);

--
-- Indici per le tabelle `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_1F1B251ECBE0B084` (`primary_media_id`);

--
-- Indici per le tabelle `item_item_set`
--
ALTER TABLE `item_item_set`
  ADD PRIMARY KEY (`item_id`,`item_set_id`),
  ADD KEY `IDX_6D0C9625126F525E` (`item_id`),
  ADD KEY `IDX_6D0C9625960278D7` (`item_set_id`);

--
-- Indici per le tabelle `item_set`
--
ALTER TABLE `item_set`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `item_site`
--
ALTER TABLE `item_site`
  ADD PRIMARY KEY (`item_id`,`site_id`),
  ADD KEY `IDX_A1734D1F126F525E` (`item_id`),
  ADD KEY `IDX_A1734D1FF6BD1646` (`site_id`);

--
-- Indici per le tabelle `job`
--
ALTER TABLE `job`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_FBD8E0F87E3C61F9` (`owner_id`);

--
-- Indici per le tabelle `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_6A2CA10C5CC5DB90` (`storage_id`),
  ADD KEY `IDX_6A2CA10C126F525E` (`item_id`),
  ADD KEY `item_position` (`item_id`,`position`),
  ADD KEY `media_type` (`media_type`);

--
-- Indici per le tabelle `migration`
--
ALTER TABLE `migration`
  ADD PRIMARY KEY (`version`);

--
-- Indici per le tabelle `module`
--
ALTER TABLE `module`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `password_creation`
--
ALTER TABLE `password_creation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C77917B4A76ED395` (`user_id`);

--
-- Indici per le tabelle `property`
--
ALTER TABLE `property`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8BF21CDEAD0E05F6623C14D5` (`vocabulary_id`,`local_name`),
  ADD KEY `IDX_8BF21CDE7E3C61F9` (`owner_id`),
  ADD KEY `IDX_8BF21CDEAD0E05F6` (`vocabulary_id`);

--
-- Indici per le tabelle `resource`
--
ALTER TABLE `resource`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_BC91F4167E3C61F9` (`owner_id`),
  ADD KEY `IDX_BC91F416448CC1BD` (`resource_class_id`),
  ADD KEY `IDX_BC91F41616131EA` (`resource_template_id`),
  ADD KEY `IDX_BC91F416FDFF2E92` (`thumbnail_id`),
  ADD KEY `title` (`title`(190)),
  ADD KEY `is_public` (`is_public`);

--
-- Indici per le tabelle `resource_class`
--
ALTER TABLE `resource_class`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C6F063ADAD0E05F6623C14D5` (`vocabulary_id`,`local_name`),
  ADD KEY `IDX_C6F063AD7E3C61F9` (`owner_id`),
  ADD KEY `IDX_C6F063ADAD0E05F6` (`vocabulary_id`);

--
-- Indici per le tabelle `resource_template`
--
ALTER TABLE `resource_template`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_39ECD52EEA750E8` (`label`),
  ADD KEY `IDX_39ECD52E7E3C61F9` (`owner_id`),
  ADD KEY `IDX_39ECD52E448CC1BD` (`resource_class_id`),
  ADD KEY `IDX_39ECD52E724734A3` (`title_property_id`),
  ADD KEY `IDX_39ECD52EB84E0D1D` (`description_property_id`);

--
-- Indici per le tabelle `resource_template_property`
--
ALTER TABLE `resource_template_property`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_4689E2F116131EA549213EC` (`resource_template_id`,`property_id`),
  ADD KEY `IDX_4689E2F116131EA` (`resource_template_id`),
  ADD KEY `IDX_4689E2F1549213EC` (`property_id`);

--
-- Indici per le tabelle `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `site`
--
ALTER TABLE `site`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_694309E4989D9B62` (`slug`),
  ADD UNIQUE KEY `UNIQ_694309E4571EDDA` (`homepage_id`),
  ADD KEY `IDX_694309E4FDFF2E92` (`thumbnail_id`),
  ADD KEY `IDX_694309E47E3C61F9` (`owner_id`);

--
-- Indici per le tabelle `site_block_attachment`
--
ALTER TABLE `site_block_attachment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_236473FEE9ED820C` (`block_id`),
  ADD KEY `IDX_236473FE126F525E` (`item_id`),
  ADD KEY `IDX_236473FEEA9FDD75` (`media_id`),
  ADD KEY `block_position` (`block_id`,`position`);

--
-- Indici per le tabelle `site_item_set`
--
ALTER TABLE `site_item_set`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_D4CE134F6BD1646960278D7` (`site_id`,`item_set_id`),
  ADD KEY `IDX_D4CE134F6BD1646` (`site_id`),
  ADD KEY `IDX_D4CE134960278D7` (`item_set_id`),
  ADD KEY `position` (`position`);

--
-- Indici per le tabelle `site_page`
--
ALTER TABLE `site_page`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_2F900BD9F6BD1646989D9B62` (`site_id`,`slug`),
  ADD KEY `is_public` (`is_public`),
  ADD KEY `IDX_2F900BD9F6BD1646` (`site_id`);

--
-- Indici per le tabelle `site_page_block`
--
ALTER TABLE `site_page_block`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_C593E731C4663E4` (`page_id`),
  ADD KEY `page_position` (`page_id`,`position`);

--
-- Indici per le tabelle `site_permission`
--
ALTER TABLE `site_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C0401D6FF6BD1646A76ED395` (`site_id`,`user_id`),
  ADD KEY `IDX_C0401D6FF6BD1646` (`site_id`),
  ADD KEY `IDX_C0401D6FA76ED395` (`user_id`);

--
-- Indici per le tabelle `site_setting`
--
ALTER TABLE `site_setting`
  ADD PRIMARY KEY (`id`,`site_id`),
  ADD KEY `IDX_64D05A53F6BD1646` (`site_id`);

--
-- Indici per le tabelle `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`);

--
-- Indici per le tabelle `user_setting`
--
ALTER TABLE `user_setting`
  ADD PRIMARY KEY (`id`,`user_id`),
  ADD KEY `IDX_C779A692A76ED395` (`user_id`);

--
-- Indici per le tabelle `value`
--
ALTER TABLE `value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_1D7758349B66727E` (`value_annotation_id`),
  ADD KEY `IDX_1D77583489329D25` (`resource_id`),
  ADD KEY `IDX_1D775834549213EC` (`property_id`),
  ADD KEY `IDX_1D7758344BC72506` (`value_resource_id`),
  ADD KEY `value` (`value`(190)),
  ADD KEY `uri` (`uri`(190)),
  ADD KEY `is_public` (`is_public`);

--
-- Indici per le tabelle `value_annotation`
--
ALTER TABLE `value_annotation`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `vocabulary`
--
ALTER TABLE `vocabulary`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_9099C97B9B267FDF` (`namespace_uri`),
  ADD UNIQUE KEY `UNIQ_9099C97B93B1868E` (`prefix`),
  ADD KEY `IDX_9099C97B7E3C61F9` (`owner_id`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `asset`
--
ALTER TABLE `asset`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `job`
--
ALTER TABLE `job`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `property`
--
ALTER TABLE `property`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=185;

--
-- AUTO_INCREMENT per la tabella `resource`
--
ALTER TABLE `resource`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT per la tabella `resource_class`
--
ALTER TABLE `resource_class`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT per la tabella `resource_template`
--
ALTER TABLE `resource_template`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `resource_template_property`
--
ALTER TABLE `resource_template_property`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT per la tabella `site`
--
ALTER TABLE `site`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `site_block_attachment`
--
ALTER TABLE `site_block_attachment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `site_item_set`
--
ALTER TABLE `site_item_set`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `site_page`
--
ALTER TABLE `site_page`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `site_page_block`
--
ALTER TABLE `site_page_block`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `site_permission`
--
ALTER TABLE `site_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `value`
--
ALTER TABLE `value`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT per la tabella `vocabulary`
--
ALTER TABLE `vocabulary`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `api_key`
--
ALTER TABLE `api_key`
  ADD CONSTRAINT `FK_C912ED9D7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`);

--
-- Limiti per la tabella `asset`
--
ALTER TABLE `asset`
  ADD CONSTRAINT `FK_2AF5A5C7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `fulltext_search`
--
ALTER TABLE `fulltext_search`
  ADD CONSTRAINT `FK_AA31FE4A7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `FK_1F1B251EBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1F1B251ECBE0B084` FOREIGN KEY (`primary_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `item_item_set`
--
ALTER TABLE `item_item_set`
  ADD CONSTRAINT `FK_6D0C9625126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_6D0C9625960278D7` FOREIGN KEY (`item_set_id`) REFERENCES `item_set` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `item_set`
--
ALTER TABLE `item_set`
  ADD CONSTRAINT `FK_1015EEEBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `item_site`
--
ALTER TABLE `item_site`
  ADD CONSTRAINT `FK_A1734D1F126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_A1734D1FF6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `job`
--
ALTER TABLE `job`
  ADD CONSTRAINT `FK_FBD8E0F87E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `media`
--
ALTER TABLE `media`
  ADD CONSTRAINT `FK_6A2CA10C126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`),
  ADD CONSTRAINT `FK_6A2CA10CBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `password_creation`
--
ALTER TABLE `password_creation`
  ADD CONSTRAINT `FK_C77917B4A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `property`
--
ALTER TABLE `property`
  ADD CONSTRAINT `FK_8BF21CDE7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_8BF21CDEAD0E05F6` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabulary` (`id`);

--
-- Limiti per la tabella `resource`
--
ALTER TABLE `resource`
  ADD CONSTRAINT `FK_BC91F41616131EA` FOREIGN KEY (`resource_template_id`) REFERENCES `resource_template` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_BC91F416448CC1BD` FOREIGN KEY (`resource_class_id`) REFERENCES `resource_class` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_BC91F4167E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_BC91F416FDFF2E92` FOREIGN KEY (`thumbnail_id`) REFERENCES `asset` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `resource_class`
--
ALTER TABLE `resource_class`
  ADD CONSTRAINT `FK_C6F063AD7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_C6F063ADAD0E05F6` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabulary` (`id`);

--
-- Limiti per la tabella `resource_template`
--
ALTER TABLE `resource_template`
  ADD CONSTRAINT `FK_39ECD52E448CC1BD` FOREIGN KEY (`resource_class_id`) REFERENCES `resource_class` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_39ECD52E724734A3` FOREIGN KEY (`title_property_id`) REFERENCES `property` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_39ECD52E7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_39ECD52EB84E0D1D` FOREIGN KEY (`description_property_id`) REFERENCES `property` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `resource_template_property`
--
ALTER TABLE `resource_template_property`
  ADD CONSTRAINT `FK_4689E2F116131EA` FOREIGN KEY (`resource_template_id`) REFERENCES `resource_template` (`id`),
  ADD CONSTRAINT `FK_4689E2F1549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `site`
--
ALTER TABLE `site`
  ADD CONSTRAINT `FK_694309E4571EDDA` FOREIGN KEY (`homepage_id`) REFERENCES `site_page` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_694309E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_694309E4FDFF2E92` FOREIGN KEY (`thumbnail_id`) REFERENCES `asset` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `site_block_attachment`
--
ALTER TABLE `site_block_attachment`
  ADD CONSTRAINT `FK_236473FE126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_236473FEE9ED820C` FOREIGN KEY (`block_id`) REFERENCES `site_page_block` (`id`),
  ADD CONSTRAINT `FK_236473FEEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `site_item_set`
--
ALTER TABLE `site_item_set`
  ADD CONSTRAINT `FK_D4CE134960278D7` FOREIGN KEY (`item_set_id`) REFERENCES `item_set` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_D4CE134F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `site_page`
--
ALTER TABLE `site_page`
  ADD CONSTRAINT `FK_2F900BD9F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`);

--
-- Limiti per la tabella `site_page_block`
--
ALTER TABLE `site_page_block`
  ADD CONSTRAINT `FK_C593E731C4663E4` FOREIGN KEY (`page_id`) REFERENCES `site_page` (`id`);

--
-- Limiti per la tabella `site_permission`
--
ALTER TABLE `site_permission`
  ADD CONSTRAINT `FK_C0401D6FA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_C0401D6FF6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `site_setting`
--
ALTER TABLE `site_setting`
  ADD CONSTRAINT `FK_64D05A53F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `user_setting`
--
ALTER TABLE `user_setting`
  ADD CONSTRAINT `FK_C779A692A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `value`
--
ALTER TABLE `value`
  ADD CONSTRAINT `FK_1D7758344BC72506` FOREIGN KEY (`value_resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1D775834549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1D77583489329D25` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`),
  ADD CONSTRAINT `FK_1D7758349B66727E` FOREIGN KEY (`value_annotation_id`) REFERENCES `value_annotation` (`id`) ON DELETE SET NULL;

--
-- Limiti per la tabella `value_annotation`
--
ALTER TABLE `value_annotation`
  ADD CONSTRAINT `FK_C03BA4EBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `vocabulary`
--
ALTER TABLE `vocabulary`
  ADD CONSTRAINT `FK_9099C97B7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
