<?php
// class Autor extends Controller
// {
//     public function __construct()
//     {
//         session_start();
//         if (empty($_SESSION['activo'])) {
//             header("location: " . base_url);
//         }
//         parent::__construct();
//         $id_user = $_SESSION['id_usuario'];
//         $perm = $this->model->verificarPermisos($id_user, "Autor");
//         if (!$perm && $id_user != 1) {
//             $this->views->getView($this, "permisos");
//             exit;
//         }
//     }
//     public function index()
//     {
//         $this->views->getView($this, "index");
//     }
//     public function listar()
//     {
//         // ...
//     }
//     public function registrar()
//     {
//         // ...
//     }
//     public function editar($id)
//     {
//         // ...
//     }
//     public function eliminar($id)
//     {
//         // ...
//     }
//     public function reingresar($id)
//     {
//         // ...
//     }
//     public function buscarAutor()
//     {
//         // ...
//     }
// }
