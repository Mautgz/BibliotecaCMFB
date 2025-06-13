CREATE TABLE IF NOT EXISTS `chatbot_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` enum('consulta','respuesta') NOT NULL,
  `mensaje` text NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fecha` (`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 