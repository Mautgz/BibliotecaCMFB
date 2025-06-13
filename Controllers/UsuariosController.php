<?php

class UsuariosController extends Controller {
    public function __construct() {
        parent::__construct();
    }

    public function index() {
        // Check if user is already logged in
        if (!empty($_SESSION['activo'])) {
            header("Location: " . base_url . "Home");
            exit;
        }
        // Load the login view
        $this->views->getView("Usuarios", "login");
    }

    public function login() {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $usuario = $_POST['usuario'] ?? '';
            $password = $_POST['password'] ?? '';

            if (empty($usuario) || empty($password)) {
                 // Handle empty fields - maybe show an error message on the login page
                 // For now, just redirect back
                 header("Location: " . base_url . "Usuarios");
                 exit;
            }

            // Load the Usuarios model
            $usuariosModel = $this->loadModel("Usuarios");
            // Get user data by username
            $data = $usuariosModel->getUsuario($usuario);

            // Verify user exists and password is correct
            if ($data && password_verify($password, $data['clave'])) {
                // Authentication successful
                $_SESSION['id_usuario'] = $data['id'];
                $_SESSION['usuario'] = $data['usuario'];
                $_SESSION['nombre'] = $data['nombre'];
                $_SESSION['activo'] = true;
                // Redirect to home page
                header("Location: " . base_url . "Home");
                exit;
            } else {
                // Authentication failed
                // Handle incorrect credentials - maybe show an error message on the login page
                 // For now, just redirect back
                 header("Location: " . base_url . "Usuarios");
                 exit;
            }
        } else {
            // If not a POST request, redirect to the index method (show login form)
            header("Location: " . base_url . "Usuarios");
            exit;
        }
    }

    public function logout() {
        session_destroy();
        header("Location: " . base_url . "Usuarios");
        exit;
    }
} 