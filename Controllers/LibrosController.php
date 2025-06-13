<?php

class LibrosController extends Controller {

    public function __construct() {
        parent::__construct();
    }

    public function index()
    {
        // Load the Libros model
        $librosModel = $this->loadModel("Libros");

        // Get the list of active books
        $data['libros'] = $librosModel->getLibros();

        // Load the view to display the books
        $this->views->getView("Libros", "index", $data);
    }

    public function save()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            // Process form submission from the modal
            $titulo = $_POST['titulo'] ?? '';
            $cantidad = $_POST['cantidad'] ?? 0;
            $editorial = $_POST['editorial'] ?? '';
            $anio_edicion = $_POST['anio_edicion'] ?? '';
            $num_pagina = $_POST['num_pagina'] ?? 0;
            $codigo_dewey = $_POST['codigo_dewey'] ?? '';
            $codigo_libro = $_POST['codigo_libro'] ?? '';
            $ubicacion = $_POST['ubicacion'] ?? '';
            $lugar = $_POST['lugar'] ?? null;
            $descripcion = $_POST['descripcion'] ?? null;
            $imagen = $_POST['imagen'] ?? null;
            $materia = $_POST['materia'] ?? null;
            $autor = $_POST['autor'] ?? null;

            // Basic validation (you can add more robust validation here)
            if (empty($titulo) || empty($cantidad) || empty($editorial) || empty($anio_edicion) || empty($num_pagina) || empty($codigo_dewey) || empty($codigo_libro) || empty($ubicacion)) {
                 // Handle validation errors - maybe return a JSON response with errors
                 // For now, just redirect back to the list page
                 header("Location: " . base_url . "Libros");
                 exit;
            }

            // Load the Libros model
            $librosModel = $this->loadModel("Libros");

            // Register the new book using the model method
            $insert = $librosModel->registrarLibro($titulo, $cantidad, $editorial, $anio_edicion, $num_pagina, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $descripcion, $imagen, $materia, $autor);

            if ($insert) {
                // Book registered successfully, redirect to the list page
                header("Location: " . base_url . "Libros");
                exit;
            } else {
                // Handle insertion error - maybe show a message on the list page
                // For now, just redirect back to the list page
                 header("Location: " . base_url . "Libros");
                 exit;
            }

        } else {
            // If not a POST request, maybe redirect to the index page or show an error
             header("Location: " . base_url . "Libros");
             exit;
        }
    }

    // We will add methods for editing, and deleting later
} 