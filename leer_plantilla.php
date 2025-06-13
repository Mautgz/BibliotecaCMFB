<?php
require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\IOFactory;

try {
    // Ruta al archivo Excel
    $inputFileName = 'Assets/plantillas/plantilla_estudiantes.xlsx';
    
    // Verificar si el archivo existe
    if (!file_exists($inputFileName)) {
        throw new Exception("El archivo no existe en la ruta especificada");
    }
    
    // Intentar leer el archivo como binario primero
    $fileContent = file_get_contents($inputFileName);
    if (empty($fileContent)) {
        throw new Exception("El archivo está vacío");
    }
    
    // Intentar cargar el archivo Excel
    $reader = IOFactory::createReader('Xlsx');
    $reader->setReadDataOnly(true);
    $spreadsheet = $reader->load($inputFileName);
    
    // Obtener la primera hoja
    $worksheet = $spreadsheet->getActiveSheet();
    
    // Obtener el rango de celdas con datos
    $highestRow = $worksheet->getHighestRow();
    $highestColumn = $worksheet->getHighestColumn();
    
    echo "Contenido de la plantilla de estudiantes:\n\n";
    
    // Leer cada fila
    for ($row = 1; $row <= $highestRow; $row++) {
        for ($col = 'A'; $col <= $highestColumn; $col++) {
            $value = $worksheet->getCell($col . $row)->getValue();
            echo $value . "\t";
        }
        echo "\n";
    }
    
} catch (Exception $e) {
    echo "Error al leer el archivo: " . $e->getMessage() . "\n";
    echo "Ruta del archivo: " . realpath($inputFileName) . "\n";
}
?> 