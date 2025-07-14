<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

class Libros extends Controller
{
    public function __construct()
    {
        session_start();
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        parent::__construct();
        $id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Libros");
        if (!$perm && $id_user != 1) {
            $this->views->getView($this, "permisos");
            exit;
        }
    }
    public function index()
    {
        $this->views->getView($this, "index");
    }
    public function listar()
    {
        try {
            $data = $this->model->getLibros();
            if ($data === false) {
                echo json_encode(['error' => 'Error al obtener los datos']);
                die();
            }
            // Debug the data
            error_log('Data from getLibros: ' . print_r($data, true));
            
            for ($i = 0; $i < count($data); $i++) {
                $data[$i]['foto'] = '<img class="img-thumbnail" src="' . base_url . "Assets/img/libros/" . $data[$i]['imagen'] . '" width="100">';
                if ($data[$i]['estado'] == 1) {
                    $data[$i]['estado'] = '<span class="badge badge-success">Activo</span>';
                    $data[$i]['acciones'] = '<div class="d-flex">
                    <button class="btn btn-primary" type="button" onclick="btnEditarLibro(' . $data[$i]['id'] . ');"><i class="fa fa-pencil-square-o"></i></button>
                    <button class="btn btn-danger" type="button" onclick="btnEliminarLibro(' . $data[$i]['id'] . ');"><i class="fa fa-trash-o"></i></button>
                    <div/>';
                } else {
                    $data[$i]['estado'] = '<span class="badge badge-danger">Inactivo</span>';
                    $data[$i]['acciones'] = '<div>
                    <button class="btn btn-success" type="button" onclick="btnReingresarLibro(' . $data[$i]['id'] . ');"><i class="fa fa-reply-all"></i></button>
                    <div/>';
                }
            }
            // Debug the final data
            error_log('Final data being sent: ' . print_r($data, true));
            
            header('Content-Type: application/json');
            echo json_encode($data, JSON_UNESCAPED_UNICODE);
        } catch (Exception $e) {
            echo json_encode(['error' => $e->getMessage()]);
        }
        die();
    }
    public function registrar()
    {
        $titulo = strClean($_POST['titulo']);
        $autor_personal = strClean($_POST['autor_personal']);
        $autor_corporativo = strClean($_POST['autor_corporativo']);
        $editorial = strClean($_POST['editorial']);
        $materia = strClean($_POST['materia']);
        $cantidad = strClean($_POST['cantidad']);
        $num_pagina = strClean($_POST['num_pagina']);
        $anio_edicion = strClean($_POST['anio_edicion']);
        $descripcion = strClean($_POST['descripcion']);
        $codigo_dewey = strClean($_POST['codigo_dewey']);
        $codigo_libro = strClean($_POST['codigo_libro']);
        $ubicacion = strClean($_POST['ubicacion']);
        $lugar = strClean($_POST['lugar']);
        $id = strClean($_POST['id']);
        $img = $_FILES['imagen'];
        $name = $img['name'];
        $fecha = date("YmdHis");
        $tmpName = $img['tmp_name'];
        if (empty($titulo) || empty($autor_personal) || empty($codigo_libro)) {
            $msg = array('msg' => 'El título, autor personal y código de libro son requeridos', 'icono' => 'warning');
        } else {
            if (!empty($name)) {
                $extension = pathinfo($name, PATHINFO_EXTENSION);
                $formatos_permitidos =  array('png', 'jpeg', 'jpg');
                if (!in_array($extension, $formatos_permitidos)) {
                    $msg = array('msg' => 'Archivo no permitido', 'icono' => 'warning');
                } else {
                    $imgNombre = $fecha . ".jpg";
                    $destino = "Assets/img/libros/" . $imgNombre;
                }
            } else if (!empty($_POST['foto_actual']) && empty($name)) {
                $imgNombre = $_POST['foto_actual'];
            } else {
                $imgNombre = "logo.png";
            }
            if ($id == "") {
                $data = $this->model->insertarLibros($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $imgNombre);
                if ($data == "ok") {
                    if (!empty($name)) {
                        move_uploaded_file($tmpName, $destino);
                    }
                    $msg = array('msg' => 'Libro registrado', 'icono' => 'success');
                } else if ($data == "existe") {
                    $msg = array('msg' => 'El libro ya existe', 'icono' => 'warning');
                } else {
                    $msg = array('msg' => 'Error al registrar', 'icono' => 'error');
                }
            } else {
                $imgDelete = $this->model->editLibros($id);
                if ($imgDelete['imagen'] != 'logo.png') {
                    if (file_exists("Assets/img/libros/" . $imgDelete['imagen'])) {
                        unlink("Assets/img/libros/" . $imgDelete['imagen']);
                    }
                }
                $data = $this->model->actualizarLibros($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $imgNombre, $id);
                if ($data == "modificado") {
                    if (!empty($name)) {
                        move_uploaded_file($tmpName, $destino);
                    }
                    $msg = array('msg' => 'Libro modificado', 'icono' => 'success');
                } else {
                    $msg = array('msg' => 'Error al modificar', 'icono' => 'error');
                }
            }
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function editar($id)
    {
        $data = $this->model->editLibros($id);
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function eliminar($id)
    {
        $data = $this->model->estadoLibros(0, $id);
        if ($data == 1) {
            $msg = array('msg' => 'Libro dado de baja', 'icono' => 'success');
        } else {
            $msg = array('msg' => 'Error al eliminar', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function reingresar($id)
    {
        $data = $this->model->estadoLibros(1, $id);
        if ($data == 1) {
            $msg = array('msg' => 'Libro restaurado', 'icono' => 'success');
        } else {
            $msg = array('msg' => 'Error al restaurar', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function verificar($id_libro)
    {
        if (is_numeric($id_libro)) {
            $data = $this->model->editLibros($id_libro);
            if (!empty($data)) {
                $msg = array('cantidad' => $data['cantidad'], 'icono' => 'success');
            }
        }else{
            $msg = array('msg' => 'Error Fatal', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function buscarLibro()
    {
        if (isset($_GET['lb'])) {
            $valor = $_GET['lb'];
            $data = $this->model->buscarLibro($valor);
            echo json_encode($data, JSON_UNESCAPED_UNICODE);
            die();
        }
    }
    public function importarExcel()
    {
        if (isset($_FILES['excel'])) {
            $file = $_FILES['excel'];
            $name = $file['name'];
            $tmpName = $file['tmp_name'];
            $extension = pathinfo($name, PATHINFO_EXTENSION);
            
            if ($extension != 'xlsx' && $extension != 'xls') {
                $msg = array('msg' => 'Solo se permiten archivos Excel', 'icono' => 'warning');
            } else {
                require_once 'vendor/autoload.php';
                
                try {
                    $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($tmpName);
                    $worksheet = $spreadsheet->getActiveSheet();
                    $rows = $worksheet->toArray();
                    
                    // Eliminar la primera fila (encabezados)
                    array_shift($rows);
                    
                    $importados = 0;
                    $errores = 0;
                    
                    foreach ($rows as $row) {
                        if (!empty($row[0])) { // Verificar que la fila no esté vacía
                            $codigo_libro = strClean($row[0]);
                            $codigo_dewey = strClean($row[1]);
                            $titulo = strClean($row[2]);
                            $autor_personal = strClean($row[3]);
                            $autor_corporativo = strClean($row[4]);
                            $editorial = strClean($row[5]);
                            $lugar = strClean($row[6]);
                            $num_pagina = strClean($row[7]);
                            
                            // Validar y formatear el año
                            $anio_edicion = strClean($row[8]);
                            if (!empty($anio_edicion) && is_numeric($anio_edicion) && strlen($anio_edicion) == 4) {
                                // Formatear el año como una fecha válida (YYYY-01-01)
                                $anio_edicion = $anio_edicion . '-01-01';
                            } else {
                                $anio_edicion = null;
                            }
                            
                            $cantidad = strClean($row[9]);
                            $ubicacion = strClean($row[10]);
                            $descripcion = strClean($row[11]);
                            $materia = strClean($row[12]);
                            
                            if (!empty($titulo) && !empty($codigo_libro)) {
                                $data = $this->model->insertarLibros($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, "logo.png");
                                if ($data == "ok") {
                                    $importados++;
                                } else {
                                    $errores++;
                                }
                            } else {
                                $errores++;
                            }
                        }
                    }
                    
                    $msg = array(
                        'msg' => "Importación completada. Libros importados: $importados, Errores: $errores",
                        'icono' => 'success'
                    );
                } catch (Exception $e) {
                    $msg = array('msg' => 'Error al procesar el archivo: ' . $e->getMessage(), 'icono' => 'error');
                }
            }
        } else {
            $msg = array('msg' => 'No se ha seleccionado ningún archivo', 'icono' => 'warning');
        }
        
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function obtenerRespuesta()
    {
        try {
            $consulta = $_POST['consulta'];
            $libros = $this->model->getLibros();
            if ($libros === false) {
                throw new Exception('Error al obtener los libros');
            }
            require_once __DIR__ . '/../TextProcessor.php';
            $tp = new TextProcessor();
            $response = $tp->find_relevant_books($consulta, $libros);
            if (isset($response['error'])) {
                throw new Exception($response['error']);
            }
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode([
                'respuesta' => $response['respuesta'],
                'libros' => $response['libros']
            ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        } catch (Exception $e) {
            error_log("Error en Chatbot::obtenerRespuesta: " . $e->getMessage());
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode([
                'error' => $e->getMessage()
            ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
        die();
    }
    public function getTotalDisponibles()
    {
        $data = [
            'total' => $this->model->getTotalLibrosDisponibles()
        ];
        echo json_encode($data);
        die();
    }
    public function inventario()
    {
        try {
            // Obtener datos de configuración
            $datos = $this->model->selectDatos();
            if (empty($datos)) {
                throw new Exception("No se encontraron datos de configuración");
            }

            // Obtener todos los libros
            $libros = $this->model->getLibros();
            if (empty($libros)) {
                header('Location: ' . base_url . 'Configuracion/vacio');
                exit;
            }

            // Incluir FPDF
            require_once 'Libraries/pdf/fpdf.php';
            
            // Crear PDF
            $pdf = new FPDF('L', 'mm', 'letter');
            $pdf->AddPage();
            $pdf->SetMargins(10, 10, 10);
            $pdf->SetTitle("Inventario de Libros");
            
            // Encabezado
            $pdf->SetFont('Arial', 'B', 12);
            $pdf->Cell(260, 7, mb_convert_encoding($datos['nombre'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'C');

            // Logo 
            $logo_path = $_SERVER['DOCUMENT_ROOT'] . '/biblio/Assets/img/logo.png';
            if (file_exists($logo_path)) {
                $pdf->Image($logo_path, 240, 15, 30, 30, 'PNG');
            }
            // Fecha de creación
            $pdf->SetFont('Arial', '', 10);
            $pdf->SetXY(200, 20);
            $pdf->Cell(50, 5, 'Fecha: ' . date('d/m/Y'), 0, 1, 'R');

            // Información de contacto
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(25, 7, mb_convert_encoding("Teléfono: ", 'ISO-8859-1', 'UTF-8'), 0, 0, 'L');
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(40, 7, mb_convert_encoding($datos['telefono'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'L');
            
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(25, 7, mb_convert_encoding("Dirección: ", 'ISO-8859-1', 'UTF-8'), 0, 0, 'L');
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(80, 7, mb_convert_encoding($datos['direccion'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'L');
            
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(25, 7, "Correo: ", 0, 0, 'L');
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(80, 7, mb_convert_encoding($datos['correo'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'L');
            
            $pdf->Ln(5);

            // Tabla de libros - optimizada para orientación apaisada
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->SetFillColor(0, 0, 0);
            $pdf->SetTextColor(255, 255, 255);
            $pdf->Cell(260, 7, mb_convert_encoding("Inventario de Libros", 'ISO-8859-1', 'UTF-8'), 1, 1, 'C', 1);
            
            // Encabezados de la tabla - ancho optimizado
            $pdf->SetTextColor(0, 0, 0);
            $pdf->Cell(12, 7, mb_convert_encoding('N°', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(80, 7, mb_convert_encoding('Título', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(50, 7, mb_convert_encoding('Autor', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(40, 7, mb_convert_encoding('Editorial', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(20, 7, mb_convert_encoding('Cantidad', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(35, 7, mb_convert_encoding('Ubicación', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(23, 7, mb_convert_encoding('Estado', 'ISO-8859-1', 'UTF-8'), 1, 1, 'L');
            
            // Datos de libros - ancho optimizado
            $pdf->SetFont('Arial', '', 8);
            $contador = 1;
            foreach ($libros as $row) {
                $pdf->Cell(12, 7, $contador, 1, 0, 'L');
                $pdf->Cell(80, 7, isset($row['titulo']) ? mb_convert_encoding(substr($row['titulo'], 0, 45), 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(50, 7, isset($row['autor_personal']) ? mb_convert_encoding(substr($row['autor_personal'], 0, 28), 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(40, 7, isset($row['editorial']) ? mb_convert_encoding(substr($row['editorial'], 0, 22), 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(20, 7, isset($row['cantidad']) ? $row['cantidad'] : '', 1, 0, 'L');
                $pdf->Cell(35, 7, isset($row['ubicacion']) ? mb_convert_encoding(substr($row['ubicacion'], 0, 20), 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(23, 7, (isset($row['estado']) && $row['estado'] == 1) ? 'Activo' : 'Inactivo', 1, 1, 'L');
                $contador++;
            }

            // Generar PDF
            $pdf->Output("inventario_libros.pdf", "I");
            
        } catch (Exception $e) {
            // Log del error
            error_log("Error en generación de PDF de inventario: " . $e->getMessage());
            
            // Redirigir a página de error
            header('Location: ' . base_url . 'Configuracion/Error');
            exit;
        }
    }

    public function buscarPorISBN()
    {
        try {
            if (!isset($_POST['isbn'])) {
                throw new Exception('ISBN no proporcionado');
            }

            $isbn = strClean($_POST['isbn']);
            
            // Limpiar el ISBN (remover guiones y espacios)
            $isbn = preg_replace('/[^0-9X]/', '', strtoupper($isbn));
            
            if (empty($isbn)) {
                throw new Exception('ISBN inválido');
            }

            // Buscar en múltiples APIs
            $libro = $this->buscarEnGoogleBooks($isbn);
            
            if (!$libro) {
                $libro = $this->buscarEnOpenLibrary($isbn);
            }

            if ($libro) {
                echo json_encode([
                    'success' => true,
                    'data' => $libro
                ], JSON_UNESCAPED_UNICODE);
            } else {
                echo json_encode([
                    'success' => false,
                    'message' => 'No se encontró información para este ISBN'
                ], JSON_UNESCAPED_UNICODE);
            }

        } catch (Exception $e) {
            echo json_encode([
                'success' => false,
                'message' => $e->getMessage()
            ], JSON_UNESCAPED_UNICODE);
        }
        die();
    }

    private function buscarEnGoogleBooks($isbn)
    {
        try {
            $url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" . urlencode($isbn) . "&langRestrict=es";
            
            $response = file_get_contents($url);
            if ($response === false) {
                return null;
            }

            $data = json_decode($response, true);
            
            if (isset($data['items']) && count($data['items']) > 0) {
                $book = $data['items'][0]['volumeInfo'];
                
                return [
                    'titulo' => $book['title'] ?? '',
                    'autor' => isset($book['authors']) ? implode(', ', $book['authors']) : '',
                    'editorial' => $book['publisher'] ?? '',
                    'anio' => $book['publishedDate'] ?? '',
                    'descripcion' => $book['description'] ?? '',
                    'portada' => isset($book['imageLinks']['thumbnail']) ? $book['imageLinks']['thumbnail'] : null,
                    'isbn' => $isbn
                ];
            }
            
            return null;
        } catch (Exception $e) {
            error_log("Error buscando en Google Books: " . $e->getMessage());
            return null;
        }
    }

    private function buscarEnOpenLibrary($isbn)
    {
        try {
            $url = "https://openlibrary.org/api/books?bibkeys=ISBN:" . urlencode($isbn) . "&format=json&jscmd=data";
            
            $response = file_get_contents($url);
            if ($response === false) {
                return null;
            }

            $data = json_decode($response, true);
            
            if (isset($data["ISBN:$isbn"])) {
                $book = $data["ISBN:$isbn"];
                
                return [
                    'titulo' => $book['title'] ?? '',
                    'autor' => isset($book['authors']) ? implode(', ', array_column($book['authors'], 'name')) : '',
                    'editorial' => isset($book['publishers']) ? implode(', ', array_column($book['publishers'], 'name')) : '',
                    'anio' => isset($book['publish_date']) ? $book['publish_date'] : '',
                    'descripcion' => isset($book['excerpts']) ? $book['excerpts'][0]['text'] : '',
                    'portada' => isset($book['cover']['large']) ? $book['cover']['large'] : null,
                    'isbn' => $isbn
                ];
            }
            
            return null;
        } catch (Exception $e) {
            error_log("Error buscando en Open Library: " . $e->getMessage());
            return null;
        }
    }

    public function buscarPorTitulo()
    {
        try {
            if (!isset($_POST['titulo'])) {
                throw new Exception('Título no proporcionado');
            }

            $titulo = strClean($_POST['titulo']);
            $titulo = trim($titulo);
            if (empty($titulo)) {
                throw new Exception('Título inválido');
            }

            // Buscar en múltiples APIs
            $libro = $this->buscarEnGoogleBooksPorTitulo($titulo);
            if (!$libro) {
                $libro = $this->buscarEnOpenLibraryPorTitulo($titulo);
            }

            if ($libro) {
                echo json_encode([
                    'success' => true,
                    'data' => $libro
                ], JSON_UNESCAPED_UNICODE);
            } else {
                echo json_encode([
                    'success' => false,
                    'message' => 'No se encontró información para este título'
                ], JSON_UNESCAPED_UNICODE);
            }
        } catch (Exception $e) {
            echo json_encode([
                'success' => false,
                'message' => $e->getMessage()
            ], JSON_UNESCAPED_UNICODE);
        }
        die();
    }

    private function buscarEnGoogleBooksPorTitulo($titulo)
    {
        try {
            $url = "https://www.googleapis.com/books/v1/volumes?q=" . urlencode($titulo) . "&langRestrict=es";
            $response = file_get_contents($url);
            if ($response === false) {
                return null;
            }
            $data = json_decode($response, true);
            if (isset($data['items']) && count($data['items']) > 0) {
                $book = $data['items'][0]['volumeInfo'];
                $isbn = '';
                if (isset($book['industryIdentifiers'])) {
                    foreach ($book['industryIdentifiers'] as $id) {
                        if ($id['type'] === 'ISBN_13' || $id['type'] === 'ISBN_10') {
                            $isbn = $id['identifier'];
                            break;
                        }
                    }
                }
                return [
                    'titulo' => $book['title'] ?? '',
                    'autor' => isset($book['authors']) ? implode(', ', $book['authors']) : '',
                    'editorial' => $book['publisher'] ?? '',
                    'anio' => $book['publishedDate'] ?? '',
                    'descripcion' => $book['description'] ?? '',
                    'portada' => isset($book['imageLinks']['thumbnail']) ? $book['imageLinks']['thumbnail'] : null,
                    'isbn' => $isbn
                ];
            }
            return null;
        } catch (Exception $e) {
            error_log("Error buscando en Google Books por título: " . $e->getMessage());
            return null;
        }
    }

    private function buscarEnOpenLibraryPorTitulo($titulo)
    {
        try {
            $url = "https://openlibrary.org/search.json?title=" . urlencode($titulo);
            $response = file_get_contents($url);
            if ($response === false) {
                return null;
            }
            $data = json_decode($response, true);
            if (isset($data['docs']) && count($data['docs']) > 0) {
                $book = $data['docs'][0];
                $isbn = isset($book['isbn'][0]) ? $book['isbn'][0] : '';
                return [
                    'titulo' => $book['title'] ?? '',
                    'autor' => isset($book['author_name']) ? implode(', ', $book['author_name']) : '',
                    'editorial' => isset($book['publisher']) ? implode(', ', $book['publisher']) : '',
                    'anio' => $book['first_publish_year'] ?? '',
                    'descripcion' => '', // OpenLibrary search API does not provide description
                    'portada' => isset($book['cover_i']) ? 'https://covers.openlibrary.org/b/id/' . $book['cover_i'] . '-L.jpg' : null,
                    'isbn' => $isbn
                ];
            }
            return null;
        } catch (Exception $e) {
            error_log("Error buscando en Open Library por título: " . $e->getMessage());
            return null;
        }
    }
}
