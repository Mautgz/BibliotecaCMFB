<?php
class Carousel extends Controller {
    public function __construct() {
        parent::__construct();
        session_start();
        if (empty($_SESSION['activo'])) {
            header('Location: ' . base_url);
            die();
        }
    }

    public function index() {
        $id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Carousel");
        if (!$perm && $id_user != 1) {
            $this->views->getView($this, "permisos");
            exit;
        }
        $data['page_id'] = 1;
        $data['page_tag'] = "Carousel";
        $data['page_title'] = "Gestión del Carousel";
        $data['page_name'] = "carousel";
        $data['page_content'] = "Lorem ipsum dolor sit amet, consectetur adipisicing elit.";
        $data['perm_config'] = $this->model->verificarPermisos($id_user, "Configuracion");
        $data['perm_libros'] = $this->model->verificarPermisos($id_user, "Libros");
        $data['perm_autor'] = $this->model->verificarPermisos($id_user, "Autor");
        $data['perm_editorial'] = $this->model->verificarPermisos($id_user, "Editorial");
        $data['perm_estudiantes'] = $this->model->verificarPermisos($id_user, "Estudiantes");
        $data['perm_materias'] = $this->model->verificarPermisos($id_user, "Materias");
        $data['perm_prestamos'] = $this->model->verificarPermisos($id_user, "Prestamos");
        $data['perm_reportes'] = $this->model->verificarPermisos($id_user, "Reportes");
        $data['perm_usuarios'] = $this->model->verificarPermisos($id_user, "Usuarios");
        $this->views->getView($this, "carousel", $data);
    }

    public function getCarouselItems() {
        $model = new CarouselModel();
        $items = $model->getCarouselItems();
        echo json_encode($items);
    }

    public function setCarouselItem() {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $model = new CarouselModel();
            
            // Validar campos requeridos
            if (empty($_POST['title']) || empty($_POST['description'])) {
                echo json_encode(['status' => false, 'msg' => 'El título y la descripción son requeridos']);
                die();
            }

            // Limpiar datos
            $title = strClean($_POST['title']);
            $description = strClean($_POST['description']);
            $button_text = strClean($_POST['button_text'] ?? '');
            $button_link = strClean($_POST['button_link'] ?? '');
            $order = intval($_POST['order_number'] ?? 0);
            $id = intval($_POST['id'] ?? 0);

            // Handle image upload
            $image_path = '';
            if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
                $upload_dir = 'Assets/img/carousel/';
                if (!file_exists($upload_dir)) {
                    mkdir($upload_dir, 0777, true);
                }

                $file_name = time() . '_' . $_FILES['image']['name'];
                $target_path = $upload_dir . $file_name;

                // Validar tipo de archivo
                $allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
                if (!in_array($_FILES['image']['type'], $allowed_types)) {
                    echo json_encode(['status' => false, 'msg' => 'Tipo de archivo no permitido']);
                    die();
                }

                if (move_uploaded_file($_FILES['image']['tmp_name'], $target_path)) {
                    $image_path = $target_path;
                } else {
                    echo json_encode(['status' => false, 'msg' => 'Error al subir la imagen']);
                    die();
                }
            } else if ($id == 0) {
                // Si es un nuevo item y no se subió imagen
                echo json_encode(['status' => false, 'msg' => 'La imagen es requerida para nuevos items']);
                die();
            } else if ($id > 0) {
                // Si es edición y no se subió imagen, obtener la anterior
                $item = $model->getCarouselItem($id);
                if ($item && !empty($item['image_path'])) {
                    $image_path = $item['image_path'];
                }
            }

            $data = [
                'title' => $title,
                'description' => $description,
                'button_text' => $button_text,
                'button_link' => $button_link,
                'order_number' => $order,
                'image_path' => $image_path
            ];

            try {
                if ($id == 0) {
                    $res = $model->addCarouselItem($data);
                } else {
                    $res = $model->updateCarouselItem($data, $id);
                }
                
                if ($res) {
                    echo json_encode(['status' => true, 'msg' => 'Item guardado correctamente']);
                } else {
                    echo json_encode(['status' => false, 'msg' => 'Error al guardar el item']);
                }
            } catch (Exception $e) {
                echo json_encode(['status' => false, 'msg' => 'Error: ' . $e->getMessage()]);
            }
        }
    }

    public function delCarouselItem() {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $model = new CarouselModel();
            $id = intval($_POST['id']);
            $res = $model->deleteCarouselItem($id);
            echo json_encode(['status' => $res, 'msg' => $res ? 'Item eliminado correctamente' : 'Error al eliminar el item']);
        }
    }

    public function updateOrder() {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $model = new CarouselModel();
            $items = $_POST['items'];
            $res = $model->updateOrder($items);
            echo json_encode(['status' => $res, 'msg' => $res ? 'Orden actualizado correctamente' : 'Error al actualizar el orden']);
        }
    }
} 