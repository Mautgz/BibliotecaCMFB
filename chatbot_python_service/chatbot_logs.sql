CREATE TABLE IF NOT EXISTS chatbot_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    query TEXT NOT NULL,
    respuesta TEXT NOT NULL,
    tiempo_respuesta FLOAT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    INDEX idx_fecha_hora (fecha_hora)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Agregar columna tiempo_respuesta a la tabla chatbot_logs
ALTER TABLE chatbot_logs ADD COLUMN tiempo_respuesta FLOAT AFTER respuesta; 