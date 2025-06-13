<?php
class Chatbot extends Controller
{
    public function __construct()
    {
        session_start();
        parent::__construct();
    }

    public function index()
    {
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        $this->views->getView($this, "index");
    }

    public function buscarLibros()
    {
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        try {
            if (!isset($_POST['query'])) {
                throw new Exception('Query parameter is required');
            }

            $query = strClean($_POST['query']);
            $libros = $this->model->getAllLibros();

            require_once __DIR__ . '/../TextProcessor.php';
            $tp = new TextProcessor();
            $librosRelevantes = $tp->find_relevant_books($query, $libros);

            if (isset($librosRelevantes['error'])) {
                throw new Exception($librosRelevantes['error']);
            }

            header('Content-Type: application/json');
            echo json_encode($librosRelevantes, JSON_UNESCAPED_UNICODE);
        } catch (Exception $e) {
            header('Content-Type: application/json');
            echo json_encode(['error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
        }
        die();
    }

    public function obtenerRespuesta()
    {
        try {
            if (!isset($_POST['query'])) {
                throw new Exception('Query parameter is required');
            }

            $query = strClean($_POST['query']);
            $libros = $this->model->getAllLibros();

            // Preparar datos para el microservicio Python
            $payload = json_encode([
                'query' => $query,
                'books' => $libros
            ], JSON_UNESCAPED_UNICODE);

            // Llamar al microservicio Python
            $ch = curl_init('http://localhost:8080/buscar_libros');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Accept: application/json'
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
            $response = curl_exec($ch);
            $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            if (curl_errno($ch)) {
                throw new Exception('Error al conectar con el microservicio Python: ' . curl_error($ch));
            }
            curl_close($ch);

            if ($httpcode !== 200) {
                throw new Exception('Microservicio Python respondió con código HTTP ' . $httpcode);
            }

            // Log the interaction (opcional: puedes extraer la respuesta del JSON)
            $respuesta_json = json_decode($response, true);
            $respuesta_texto = isset($respuesta_json['respuesta']) ? $respuesta_json['respuesta'] : '';
            $this->logChatbotInteraction($query, $respuesta_texto);

            header('Content-Type: application/json; charset=utf-8');
            echo $response;
        } catch (Exception $e) {
            error_log("Error en Chatbot::obtenerRespuesta: " . $e->getMessage());
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode([
                'error' => $e->getMessage()
            ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
        die();
    }

    private function logChatbotInteraction($mensaje, $respuesta)
    {
        try {
            $sql = "INSERT INTO chatbot_logs (mensaje, respuesta) VALUES (?, ?)";
            $datos = array($mensaje, $respuesta);
            $this->model->insert($sql, $datos);
        } catch (Exception $e) {
            error_log("Error al guardar log del chatbot: " . $e->getMessage());
        }
    }

    private function procesarConsultaEstudiantes($query)
    {
        $estudiantes = $this->model->getAllEstudiantes();
        $resultado = [];

        // Buscar por nombre o código
        if (preg_match('/(\d+)/', $query, $matches)) {
            // Búsqueda por código
            $codigo = $matches[1];
            $estudiantes = array_filter($estudiantes, function($est) use ($codigo) {
                return strpos($est['codigo'], $codigo) !== false;
            });
        } else {
            // Búsqueda por nombre
            $palabras = explode(' ', $query);
            $estudiantes = array_filter($estudiantes, function($est) use ($palabras) {
                $nombreCompleto = strtolower($est['nombre'] . ' ' . $est['apellido']);
                foreach ($palabras as $palabra) {
                    if (strpos($nombreCompleto, strtolower($palabra)) !== false) {
                        return true;
                    }
                }
                return false;
            });
        }

        if (empty($estudiantes)) {
            return [
                'respuesta' => 'No encontré estudiantes que coincidan con tu búsqueda.',
                'estudiantes' => []
            ];
        }

        $estudiantes = array_values($estudiantes);
        return [
            'respuesta' => 'He encontrado ' . count($estudiantes) . ' estudiante(s) que coinciden con tu búsqueda.',
            'estudiantes' => array_slice($estudiantes, 0, 5) // Limitar a 5 resultados
        ];
    }

    private function procesarConsultaPrestamos($query)
    {
        $prestamos = $this->model->getAllPrestamos();
        $resultado = [];

        // Buscar por código de estudiante o libro
        if (preg_match('/(\d+)/', $query, $matches)) {
            $codigo = $matches[1];
            $prestamos = array_filter($prestamos, function($prestamo) use ($codigo) {
                return strpos($prestamo['codigo_estudiante'], $codigo) !== false ||
                       strpos($prestamo['codigo_libro'], $codigo) !== false;
            });
        }

        // Filtrar por estado si se menciona
        if (stripos($query, 'activo') !== false) {
            $prestamos = array_filter($prestamos, function($prestamo) {
                return $prestamo['estado'] === 'Activo';
            });
        } elseif (stripos($query, 'vencido') !== false || stripos($query, 'atrasado') !== false) {
            $prestamos = array_filter($prestamos, function($prestamo) {
                return $prestamo['estado'] === 'Vencido';
            });
        }

        if (empty($prestamos)) {
            return [
                'respuesta' => 'No encontré préstamos que coincidan con tu búsqueda.',
                'prestamos' => []
            ];
        }

        $prestamos = array_values($prestamos);
        return [
            'respuesta' => 'He encontrado ' . count($prestamos) . ' préstamo(s) que coinciden con tu búsqueda.',
            'prestamos' => array_slice($prestamos, 0, 5) // Limitar a 5 resultados
        ];
    }
} 