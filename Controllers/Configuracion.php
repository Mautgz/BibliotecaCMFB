<?php
class Configuracion extends Controller
{
    private $db;
    public function __construct()
    {
        session_start();
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        parent::__construct();
        $this->db = new mysqli(host, user, pass, db);
        if ($this->db->connect_error) {
            die('Error de conexión (' . $this->db->connect_errno . ') ' . $this->db->connect_error);
        }
        $this->db->set_charset('utf8');
    }
    public function index()
    {
		$id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Configuracion");
        if (!$perm && $id_user != 1) {
            $this->views->getView($this, "permisos");
            exit;
        }
        $data = $this->model->selectConfiguracion();
        $this->views->getView($this, "index", $data);
    }
    public function actualizar()
    {
		$id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Configuracion");
        if (!$perm && $id_user != 1) {
            $this->views->getView($this, "permisos");
            exit;
        }
        $id = strClean($_POST['id']);
        $nombre = strClean($_POST['nombre']);
        $telefono = strClean($_POST['telefono']);
        $direccion = strClean($_POST['direccion']);
        $correo = strClean($_POST['correo']);
        $img = $_FILES['imagen'];
        $tmpName = $img['tmp_name'];
        if (empty($id) || empty($nombre) || empty($telefono) || empty($direccion) || empty($correo)) {
            $msg = array('msg' => 'Todo los campos son requeridos', 'icono' => 'warning');
        } else {
            $name = "logo.png";
            $destino = 'Assets/img/logo.png';
            $data = $this->model->actualizarConfig($nombre, $telefono, $direccion, $correo, $name, $id);
            if ($data == "modificado") {
                $msg = array('msg' => 'Datos de la empresa modificado', 'icono' => 'success');
                if (!empty($img['name'])) {
                    $extension = pathinfo($img['name'], PATHINFO_EXTENSION);
                    $formatos_permitidos =  array('png', 'jpeg', 'jpg');
                    $extension = pathinfo($img['name'], PATHINFO_EXTENSION);
                    if (!in_array($extension, $formatos_permitidos)) {
                        $msg = array('msg' => 'Archivo no permitido', 'icono' => 'warning');
                    }else{
                        move_uploaded_file($tmpName, $destino);
                    }
                }
            }
        }
        
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function admin()
    {
        $data['libros'] = $this->model->selectDatos('libro');
        $data['materias'] = $this->model->selectDatos('materia');
        $data['estudiantes'] = $this->model->selectDatos('estudiante');
        $data['autor'] = $this->model->selectDatos('autor');
        $data['editorial'] = $this->model->selectDatos('editorial');
        $data['prestamos'] = $this->model->selectDatos('prestamo');
        $data['usuarios'] = $this->model->selectDatos('usuarios');
        $this->views->getView($this, "home", $data);
    }
    public function grafico()
    {
        $data = [];

        // Libros por materia
        $materias = $this->model->getLibrosPorMateria();
        foreach ($materias as $materia) {
            $data[] = [
                'tipo' => 'materia',
                'nombre' => $materia['materia'],
                'cantidad' => $materia['cantidad']
            ];
        }

        // Préstamos por estado
        $prestamos = $this->model->getPrestamosEstado();
        foreach ($prestamos as $prestamo) {
            $data[] = [
                'tipo' => 'prestamo',
                'estado' => $prestamo['estado'],
                'cantidad' => $prestamo['cantidad']
            ];
        }

        echo json_encode($data);
        die();
    }
    public function Error()
    {
        $this->views->getView($this, "error");
    }
    public function vacio()
    {
        $this->views->getView($this, "vacio");
    }
    public function verificar()
    {
        $date = date('Y-m-d');
        $data = $this->model->getVerificarPrestamos($date);
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function libros()
    {
        $datos = $this->model->selectConfiguracion();
        $date = date('Y-m-d');
        $prestamo = $this->model->getVerificarPrestamos($date);
        if (empty($prestamo)) {
            header('Location: ' . base_url . 'Configuracion/vacio');
        }
        require_once 'Libraries/pdf/fpdf.php';
        $pdf = new FPDF('P', 'mm', 'letter');
        $pdf->AddPage();
        $pdf->SetMargins(10, 10, 10);
        $pdf->SetTitle(iconv('ISO-8859-1', 'UTF-8', "Prestamos"), true);
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(195, 5, utf8_decode($datos['nombre']), 0, 1, 'C');

        $pdf->Image(base_url . "Assets/img/logo.png", 180, 10, 30, 30, 'PNG');
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(20, 5, utf8_decode("Teléfono: "), 0, 0, 'L');
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(20, 5, $datos['telefono'], 0, 1, 'L');
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(20, 5, utf8_decode("Dirección: "), 0, 0, 'L');
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(20, 5, utf8_decode($datos['direccion']), 0, 1, 'L');
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(20, 5, "Correo: ", 0, 0, 'L');
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(20, 5, utf8_decode($datos['correo']), 0, 1, 'L');
        $pdf->Ln();
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->SetFillColor(0, 0, 0);
        $pdf->SetTextColor(255, 255, 255);
        $pdf->Cell(196, 5, "Detalle de Prestamos", 1, 1, 'C', 1);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Cell(14, 5, utf8_decode('N°'), 1, 0, 'L');
        $pdf->Cell(50, 5, utf8_decode('Estudiantes'), 1, 0, 'L');
        $pdf->Cell(87, 5, 'Libros', 1, 0, 'L');
        $pdf->Cell(30, 5, 'Fecha Prestamo', 1, 0, 'L');
        $pdf->Cell(15, 5, 'Cant.', 1, 1, 'L');
        $pdf->SetFont('Arial', '', 10);
        $contador = 1;
        foreach ($prestamo as $row) {
            $pdf->Cell(14, 5, $contador, 1, 0, 'L');
            $pdf->Cell(50, 5, $row['nombre'], 1, 0, 'L');
            $pdf->Cell(87, 5, utf8_decode($row['titulo']), 1, 0, 'L');
            $pdf->Cell(30, 5, $row['fecha_prestamo'], 1, 0, 'L');
            $pdf->Cell(15, 5, $row['cantidad'], 1, 1, 'L');
            $contador++;
        }
        $pdf->Output('I', 'prestamos.pdf');
    }
    // FAQs CRUD
    public function listarFaqs() {
        $result = $this->db->query("SELECT * FROM faqs");
        $faqs = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($faqs, JSON_UNESCAPED_UNICODE);
    }

    public function agregarFaq() {
        error_log('ID usuario en sesión: ' . (isset($_SESSION['id_usuario']) ? $_SESSION['id_usuario'] : 'NO DEFINIDO'));
        error_log('Activo en sesión: ' . (isset($_SESSION['activo']) ? $_SESSION['activo'] : 'NO DEFINIDO'));
        $id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Configuracion");
        if (!$perm && $id_user != 1) {
            echo json_encode(['error' => 'No tienes permisos para esta acción.']);
            die();
        }
        $pregunta = $_POST['pregunta'];
        $respuesta = $_POST['respuesta'];
        $patron = $_POST['patron_regex'] ?? null;
        $stmt = $this->db->prepare("INSERT INTO faqs (pregunta, respuesta, patron_regex) VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $pregunta, $respuesta, $patron);
        $stmt->execute();
        $this->exportarFaqsJson();
        echo json_encode(['success' => true]);
    }

    public function editarFaq() {
        $id = $_POST['id'];
        $pregunta = $_POST['pregunta'];
        $respuesta = $_POST['respuesta'];
        $patron = $_POST['patron_regex'] ?? null;
        $stmt = $this->db->prepare("UPDATE faqs SET pregunta=?, respuesta=?, patron_regex=? WHERE id=?");
        $stmt->bind_param("sssi", $pregunta, $respuesta, $patron, $id);
        $stmt->execute();
        $this->exportarFaqsJson();
        echo json_encode(['success' => true]);
    }

    public function eliminarFaq() {
        $id = $_POST['id'];
        $stmt = $this->db->prepare("DELETE FROM faqs WHERE id=?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $this->exportarFaqsJson();
        echo json_encode(['success' => true]);
    }

    private function exportarFaqsJson() {
        $result = $this->db->query("SELECT * FROM faqs");
        $faqs = $result->fetch_all(MYSQLI_ASSOC);
        file_put_contents(__DIR__ . '/../scripts/faqs.json', json_encode($faqs, JSON_UNESCAPED_UNICODE));
    }

    public function getConsultasFrecuentes() {
        $sql = "SELECT mensaje as consulta, COUNT(*) as frecuencia, 
                MAX(fecha_hora) as ultima_consulta 
                FROM chatbot_logs 
                GROUP BY mensaje 
                ORDER BY frecuencia DESC 
                LIMIT 10";
        $result = $this->db->query($sql);
        $consultas = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($consultas, JSON_UNESCAPED_UNICODE);
        die();
    }
}
