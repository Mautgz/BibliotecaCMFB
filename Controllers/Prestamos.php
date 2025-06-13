<?php
class Prestamos extends Controller
{
    public function __construct()
    {
        session_start();
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        parent::__construct();
        $id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Prestamos");
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
        $data = $this->model->getPrestamos();
        for ($i = 0; $i < count($data); $i++) {
            if ($data[$i]['estado'] == 1) {
                $data[$i]['estado'] = '<span class="badge badge-secondary">Prestado</span>';
                $data[$i]['acciones'] = '<div>
                <button class="btn btn-primary" type="button" onclick="btnEntregar(' . $data[$i]['id'] . ');"><i class="fa fa-hourglass-start"></i></button>
                <a class="btn btn-danger" target="_blank" href="'.base_url.'Prestamos/ticked/'. $data[$i]['id'].'"><i class="fa fa-file-pdf-o"></i></a>
                <div/>';
            } else {
                $data[$i]['estado'] = '<span class="badge badge-primary">Devuelto</span>';
                $data[$i]['acciones'] = '<div>
                <a class="btn btn-danger" target="_blank" href="'.base_url.'Prestamos/ticked/'. $data[$i]['id'].'"><i class="fa fa-file-pdf-o"></i></a>
                <div/>';
            }
        }
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function registrar()
    {
        $libro = strClean($_POST['libro']);
        $estudiante = strClean($_POST['estudiante']);
        $cantidad = strClean($_POST['cantidad']);
        $fecha_prestamo = strClean($_POST['fecha_prestamo']);
        $fecha_devolucion = strClean($_POST['fecha_devolucion']);
        $observacion = strClean($_POST['observacion']);
        if (empty($libro) || empty($estudiante) || empty($cantidad) || empty($fecha_prestamo) || empty($fecha_devolucion)) {
            $msg = array('msg' => 'Todo los campos son requeridos', 'icono' => 'warning');
        } else {
            $verificar_cant = $this->model->getCantLibro($libro);
            if ($verificar_cant['cantidad'] >= $cantidad) {
                $data = $this->model->insertarPrestamo($estudiante,$libro, $cantidad, $fecha_prestamo, $fecha_devolucion, $observacion);
                if ($data > 0) {
                    $msg = array('msg' => 'Libro Prestado', 'icono' => 'success', 'id' => $data);
                } else if ($data == "existe") {
                    $msg = array('msg' => 'El libro ya esta prestado', 'icono' => 'warning');
                } else {
                    $msg = array('msg' => 'Error al prestar', 'icono' => 'error');
                }
            }else{
                $msg = array('msg' => 'Stock no disponible', 'icono' => 'warning');
            }
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function entregar($id)
    {
        $datos = $this->model->actualizarPrestamo(0, $id);
        if ($datos == "ok") {
            $msg = array('msg' => 'Libro recibido', 'icono' => 'success');
        }else{
            $msg = array('msg' => 'Error al recibir el libro', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();

    }
    public function pdf()
    {
        try {
            // Obtener datos de configuración
            $datos = $this->model->selectDatos();
            if (empty($datos)) {
                throw new Exception("No se encontraron datos de configuración");
            }

            // Obtener préstamos
            $prestamo = $this->model->selectPrestamoDebe();
            if (empty($prestamo)) {
                die('No hay préstamos activos.');
            }

            // Incluir FPDF
            require_once 'Libraries/pdf/fpdf.php';
            
            // Crear PDF
            $pdf = new FPDF('P', 'mm', 'letter');
            $pdf->AddPage();
            $pdf->SetMargins(10, 10, 10);
            $pdf->SetTitle("Prestamos");
            
            // Encabezado
            $pdf->SetFont('Arial', 'B', 12);
            $pdf->Cell(195, 5, mb_convert_encoding($datos['nombre'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'C');

            // Logo
            $logo_path = $_SERVER['DOCUMENT_ROOT'] . '/biblio/Assets/img/logo.png';
            if (file_exists($logo_path)) {
                $pdf->Image($logo_path, 180, 10, 30, 30, 'PNG');
            }

            // Fecha de creación
            $pdf->SetFont('Arial', '', 10);
            $pdf->SetXY(150, 15);
            $pdf->Cell(50, 5, 'Fecha: ' . date('d/m/Y'), 0, 1, 'R');

            // Información de contacto
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(20, 5, mb_convert_encoding("Teléfono: ", 'ISO-8859-1', 'UTF-8'), 0, 0, 'L');
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(20, 5, mb_convert_encoding($datos['telefono'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'L');
            
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(20, 5, mb_convert_encoding("Dirección: ", 'ISO-8859-1', 'UTF-8'), 0, 0, 'L');
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(20, 5, mb_convert_encoding($datos['direccion'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'L');
            
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(20, 5, "Correo: ", 0, 0, 'L');
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(20, 5, mb_convert_encoding($datos['correo'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'L');
            
            $pdf->Ln();

            // Tabla de préstamos
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->SetFillColor(0, 0, 0);
            $pdf->SetTextColor(255, 255, 255);
            $pdf->Cell(196, 7, mb_convert_encoding("Detalle de Préstamos", 'ISO-8859-1', 'UTF-8'), 1, 1, 'C', 1);
            // Encabezados de la tabla
            $pdf->SetTextColor(0, 0, 0);
            $pdf->Cell(14, 7, mb_convert_encoding('N°', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(25, 7, mb_convert_encoding('ID Estudiante', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(25, 7, mb_convert_encoding('ID Libro', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(35, 7, mb_convert_encoding('Fecha Préstamo', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(35, 7, mb_convert_encoding('Fecha Devolución', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(15, 7, mb_convert_encoding('Cant.', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(40, 7, mb_convert_encoding('Observación', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(20, 7, mb_convert_encoding('Estado', 'ISO-8859-1', 'UTF-8'), 1, 1, 'L');
            // Datos de préstamos
            $pdf->SetFont('Arial', '', 10);
            $contador = 1;
            foreach ($prestamo as $row) {
                $pdf->Cell(14, 7, $contador, 1, 0, 'L');
                $pdf->Cell(25, 7, isset($row['id_estudiante']) ? $row['id_estudiante'] : '', 1, 0, 'L');
                $pdf->Cell(25, 7, isset($row['id_libro']) ? $row['id_libro'] : '', 1, 0, 'L');
                $pdf->Cell(35, 7, isset($row['fecha_prestamo']) ? $row['fecha_prestamo'] : '', 1, 0, 'L');
                $pdf->Cell(35, 7, isset($row['fecha_devolucion']) ? $row['fecha_devolucion'] : '', 1, 0, 'L');
                $pdf->Cell(15, 7, isset($row['cantidad']) ? $row['cantidad'] : '', 1, 0, 'L');
                $pdf->Cell(40, 7, isset($row['observacion']) ? mb_convert_encoding($row['observacion'], 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(20, 7, (isset($row['estado']) && $row['estado'] == 1) ? 'Activo' : 'Inactivo', 1, 1, 'L');
                $contador++;
            }

            // Generar PDF
            $pdf->Output("prestamos.pdf", "I");
            
        } catch (Exception $e) {
            // Log del error
            error_log("Error en generación de PDF: " . $e->getMessage());
            
            // Redirigir a página de error
            header('Location: ' . base_url . 'Configuracion/Error');
            exit;
        }
    }
    public function ticked($id_prestamo)
    {
        // Limpiar cualquier salida previa
        while (ob_get_level()) {
            ob_end_clean();
        }
        
        $datos = $this->model->selectDatos();
        $prestamo = $this->model->getPrestamoLibro($id_prestamo);
        
        if (empty($prestamo)) {
            header('Location: '.base_url. 'Configuracion/vacio');
            exit;
        }

        require_once 'Libraries/pdf/fpdf.php';
        $pdf = new FPDF('P', 'mm', array(80, 200));
        $pdf->AddPage();
        $pdf->SetMargins(5, 5, 5);
        $pdf->SetTitle("Prestamos");
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(65, 5, iconv('UTF-8', 'ISO-8859-1', $datos['nombre']), 0, 1, 'C');

        $pdf->Image(base_url . "Assets/img/logo.png", 55, 15, 20, 20, 'PNG');
        $pdf->SetFont('Arial', 'B', 8);
        $pdf->Cell(15, 5, iconv('UTF-8', 'ISO-8859-1', "Teléfono: "), 0, 0, 'L');
        $pdf->SetFont('Arial', '', 8);
        $pdf->Cell(15, 5, $datos['telefono'], 0, 1, 'L');
        $pdf->SetFont('Arial', 'B', 8);
        $pdf->Cell(15, 5, iconv('UTF-8', 'ISO-8859-1', "Dirección: "), 0, 0, 'L');
        $pdf->SetFont('Arial', '', 8);
        $pdf->Cell(15, 5, iconv('UTF-8', 'ISO-8859-1', $datos['direccion']), 0, 1, 'L');
        $pdf->SetFont('Arial', 'B', 8);
        $pdf->Cell(15, 5, "Correo: ", 0, 0, 'L');
        $pdf->SetFont('Arial', '', 8);
        $pdf->Cell(15, 5, iconv('UTF-8', 'ISO-8859-1', $datos['correo']), 0, 1, 'L');
        $pdf->Ln();
        $pdf->SetFont('Arial', 'B', 8);
        $pdf->SetFillColor(0, 0, 0);
        $pdf->SetTextColor(255, 255, 255);
        $pdf->Cell(72, 5, "Detalle de Prestamos", 1, 1, 'C', 1);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Cell(60, 5, 'Libros', 1, 0, 'L');
        $pdf->Cell(12, 5, 'Cant.', 1, 1, 'L');
        $pdf->SetFont('Arial', '', 8);
        $pdf->Cell(60, 5, iconv('UTF-8', 'ISO-8859-1', $prestamo['titulo']), 1, 0, 'L');
        $pdf->Cell(12, 5, $prestamo['cantidad'], 1, 1, 'L');
        $pdf->Ln();
        $pdf->SetFillColor(0, 0, 0);
        $pdf->SetTextColor(255, 255, 255);
        $pdf->Cell(72, 5, "Estudiante", 1, 1, 'C', 1);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Cell(35, 5, 'Nombre', 1, 0, 'L');
        $pdf->Cell(37, 5, 'Año', 1, 1, 'L');
        $pdf->SetFont('Arial', '', 8);
        $pdf->Cell(35, 5, iconv('UTF-8', 'ISO-8859-1', $prestamo['nombre']), 1, 0, 'L');
        $pdf->Cell(37, 5, $prestamo['año'], 1, 1, 'L');
        $pdf->Ln();
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(72, 5, 'Fecha Prestamo', 0, 1, 'C');
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(72, 5, $prestamo['fecha_prestamo'], 0, 1, 'C');
        
        $pdf->Output('I', 'prestamos.pdf');
        exit;
    }
    public function buscarPorFecha()
    {
        $fecha_inicio = $_POST['fecha_inicio'];
        $fecha_fin = $_POST['fecha_fin'];
        $data = $this->model->buscarPrestamosPorFecha($fecha_inicio, $fecha_fin);
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function getTotales()
    {
        $data = [
            'prestamos_activos' => $this->model->getTotalPrestamosActivos(),
            'prestamos_devueltos' => $this->model->getTotalPrestamosDevueltos()
        ];
        echo json_encode($data);
        die();
    }
}
