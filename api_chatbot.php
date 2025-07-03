<?php
header('Content-Type: application/json');

// Incluye el controlador del chatbot y cualquier dependencia necesaria
require_once 'Controllers/Chatbot.php';

// Simula el entorno mínimo necesario para el controlador
if (!defined('base_url')) {
    define('base_url', 'http://localhost/biblio/'); // Ajusta si tu base_url es diferente
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $pregunta = $input['pregunta'] ?? '';

    // Instancia el controlador y llama al método real
    $chatbot = new Chatbot();

    // Simula el POST esperado por obtenerRespuesta
    $_POST['query'] = $pregunta;

    // Captura la salida del método (ya que usa echo)
    ob_start();
    $chatbot->obtenerRespuesta();
    $output = ob_get_clean();

    // Devuelve la respuesta JSON generada por tu chatbot
    echo $output;
    exit;
}

echo json_encode(['error' => 'Método no permitido']);
exit;