<?php
require_once 'Models/EstudiantesModel.php';

class Alumnos extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new EstudiantesModel();
    }

    public function listado()
    {
        try {
            // Obtener datos de configuración
            $datos = $this->model->selectDatos();
            if (empty($datos)) {
                throw new Exception("No se encontraron datos de configuración");
            }

            // Obtener todos los alumnos
            $alumnos = $this->model->getAlumnos();
            if (empty($alumnos)) {
                die('No hay alumnos registrados.');
            }

            // Incluir FPDF
            require_once 'Libraries/pdf/fpdf.php';
            
            // Crear PDF
            $pdf = new FPDF('L', 'mm', 'letter');
            $pdf->AddPage();
            $pdf->SetMargins(10, 10, 10);
            $pdf->SetTitle("Listado de Alumnos");
            
            // Encabezado
            $pdf->SetFont('Arial', 'B', 12);
            $pdf->Cell(260, 7, mb_convert_encoding($datos['nombre'], 'ISO-8859-1', 'UTF-8'), 0, 1, 'C');

            // Logo
            $logo_path = $_SERVER['DOCUMENT_ROOT'] . '/biblio/Assets/img/logo.png';
            if (file_exists($logo_path)) {
                $pdf->Image($logo_path, 240, 10, 30, 30, 'PNG');
            }
            // Fecha de creación
            $pdf->SetFont('Arial', '', 10);
            $pdf->SetXY(200, 15);
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
            
            $pdf->Ln();

            // Tabla de alumnos
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->SetFillColor(0, 0, 0);
            $pdf->SetTextColor(255, 255, 255);
            $pdf->Cell(260, 7, mb_convert_encoding("Listado de Alumnos", 'ISO-8859-1', 'UTF-8'), 1, 1, 'C', 1);
            
            // Encabezados de la tabla
            $pdf->SetTextColor(0, 0, 0);
            $pdf->Cell(14, 7, mb_convert_encoding('N°', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(30, 7, mb_convert_encoding('Código', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(30, 7, 'DNI', 1, 0, 'L');
            $pdf->Cell(50, 7, mb_convert_encoding('Nombre', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(20, 7, mb_convert_encoding('Año', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(50, 7, mb_convert_encoding('Dirección', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(30, 7, mb_convert_encoding('Teléfono', 'ISO-8859-1', 'UTF-8'), 1, 0, 'L');
            $pdf->Cell(26, 7, mb_convert_encoding('Estado', 'ISO-8859-1', 'UTF-8'), 1, 1, 'L');
            
            // Datos de alumnos
            $pdf->SetFont('Arial', '', 10);
            $contador = 1;
            foreach ($alumnos as $row) {
                $pdf->Cell(14, 7, $contador, 1, 0, 'L');
                $pdf->Cell(30, 7, isset($row['codigo']) ? mb_convert_encoding($row['codigo'], 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(30, 7, isset($row['dni']) ? $row['dni'] : '', 1, 0, 'L');
                $pdf->Cell(50, 7, isset($row['nombre']) ? mb_convert_encoding($row['nombre'], 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(20, 7, isset($row['año']) ? $row['año'] : '', 1, 0, 'L');
                $pdf->Cell(50, 7, isset($row['direccion']) ? mb_convert_encoding($row['direccion'], 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(30, 7, isset($row['telefono']) ? mb_convert_encoding($row['telefono'], 'ISO-8859-1', 'UTF-8') : '', 1, 0, 'L');
                $pdf->Cell(26, 7, (isset($row['estado']) && $row['estado'] == 1) ? 'Activo' : 'Inactivo', 1, 1, 'L');
                $contador++;
            }

            // Generar PDF
            $pdf->Output("listado_alumnos.pdf", "I");
            
        } catch (Exception $e) {
            die("Error: " . $e->getMessage());
        }
    }
} 