<?php
class TextProcessor
{
    public function find_relevant_books($query, $books)
    {
        // Preparar los datos para el microservicio Flask
        $data = [
            'query' => $query,
            'books' => $books
        ];
        $jsonData = json_encode($data, JSON_UNESCAPED_UNICODE);

        // Inicializar cURL
        $ch = curl_init('http://localhost:8080/buscar_libros');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Accept: application/json'
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
        curl_setopt($ch, CURLOPT_TIMEOUT, 300);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 60);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($response === false || $httpCode !== 200) {
            return [
                'error' => 'Error al conectar con el microservicio Flask: ' . $curlError . ' (HTTP ' . $httpCode . ')'
            ];
        }

        $result = json_decode($response, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            return [
                'error' => 'Respuesta inválida del microservicio Flask: ' . $response
            ];
        }
        return $result;
    }
} 