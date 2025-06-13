<?php
require_once 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class Plantillas extends Controller {
    public function __construct() {
        session_start();
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        parent::__construct();
    }

    public function generarPlantillaLibros() {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        // Establecer encabezados
        $sheet->setCellValue('A1', 'Código Libro');
        $sheet->setCellValue('B1', 'Código Dewey');
        $sheet->setCellValue('C1', 'Título');
        $sheet->setCellValue('D1', 'Autor Personal');
        $sheet->setCellValue('E1', 'Autor Corporativo');
        $sheet->setCellValue('F1', 'Editorial');
        $sheet->setCellValue('G1', 'Lugar');
        $sheet->setCellValue('H1', 'Número de Páginas');
        $sheet->setCellValue('I1', 'Año Edición');
        $sheet->setCellValue('J1', 'Cantidad');
        $sheet->setCellValue('K1', 'Ubicación');
        $sheet->setCellValue('L1', 'Descripción');
        $sheet->setCellValue('M1', 'Materia');

        // Estilo para los encabezados
        $headerStyle = [
            'font' => [
                'bold' => true,
            ],
            'alignment' => [
                'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
            ],
            'fill' => [
                'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
                'startColor' => [
                    'rgb' => 'CCCCCC',
                ],
            ],
        ];

        $sheet->getStyle('A1:M1')->applyFromArray($headerStyle);

        // Autoajustar el ancho de las columnas
        foreach(range('A','M') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }

        // Configurar el writer
        $writer = new Xlsx($spreadsheet);
        
        // Establecer headers para descarga
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="plantilla_libros.xlsx"');
        header('Cache-Control: max-age=0');

        // Guardar el archivo
        $writer->save('php://output');
        exit;
    }
} 