<?php
class PublicLibros extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index()
    {
        // Obtener parámetros de búsqueda
        $title = isset($_GET['title']) ? trim($_GET['title']) : '';
        $author = isset($_GET['author']) ? trim($_GET['author']) : '';
        $dewey = isset($_GET['dewey']) ? trim($_GET['dewey']) : '';
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
        $per_page = 12; // Libros por página

        // Obtener libros con filtros y paginación
        $result = $this->model->getLibros($title, $author, $dewey, $page, $per_page);
        
        $data['libros'] = $result['libros'];
        $data['total_pages'] = $result['total_pages'];
        $data['current_page'] = $page;

        // Mantener los filtros en la vista
        $data['filters'] = [
            'title' => $title,
            'author' => $author,
            'dewey' => $dewey
        ];

        $this->views->getView($this, "public_libros", $data);
    }
}