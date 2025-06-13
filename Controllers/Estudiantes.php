<?php
class Estudiantes extends Controller
{
    public function __construct()
    {
        session_start();
        if (empty($_SESSION['activo'])) {
            header("location: " . base_url);
        }
        parent::__construct();
        $id_user = $_SESSION['id_usuario'];
        $perm = $this->model->verificarPermisos($id_user, "Estudiantes");
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
        $data = $this->model->getEstudiantes();
        for ($i = 0; $i < count($data); $i++) {
            if ($data[$i]['estado'] == 1) {
                $data[$i]['estado'] = '<span class="badge badge-success">Activo</span>';
                $data[$i]['acciones'] = '<div>
                <button class="btn btn-primary" type="button" onclick="btnEditarEst(' . $data[$i]['id'] . ');"><i class="fa fa-pencil-square-o"></i></button>
                <button class="btn btn-danger" type="button" onclick="btnEliminarEst(' . $data[$i]['id'] . ');"><i class="fa fa-trash-o"></i></button>
                <div/>';
            } else {
                $data[$i]['estado'] = '<span class="badge badge-danger">Inactivo</span>';
                $data[$i]['acciones'] = '<div>
                <button class="btn btn-success" type="button" onclick="btnReingresarEst(' . $data[$i]['id'] . ');"><i class="fa fa-reply-all"></i></button>
                <button class="btn btn-danger" type="button" onclick="btnEliminarDefinitivoEst(' . $data[$i]['id'] . ');"><i class="fa fa-trash"></i> Eliminar permanentemente</button>
                <div/>';
            }
        }
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function registrar()
    {
        $codigo = strClean($_POST['codigo']);
        $dni = strClean($_POST['dni']);
        $nombre = strClean($_POST['nombre']);
        $año = strClean($_POST['año']);
        $direccion = strClean($_POST['direccion']);
        $telefono = strClean($_POST['telefono']);
        $id = strClean($_POST['id']);
        if (empty($codigo) || empty($dni) || empty($nombre) || empty($año)) {
            $msg = array('msg' => 'Todo los campos son requeridos', 'icono' => 'warning');
        } else {
            if ($id == "") {
                $data = $this->model->insertarEstudiante($codigo, $dni, $nombre, $año, $direccion, $telefono);
                if ($data == "ok") {
                    $msg = array('msg' => 'Estudiante registrado', 'icono' => 'success');
                } else if ($data == "existe") {
                    $msg = array('msg' => 'El código del estudiante ya existe', 'icono' => 'warning');
                } else if ($data == "dni_existe") {
                    $msg = array('msg' => 'El DNI del estudiante ya está registrado', 'icono' => 'warning');
                } else {
                    $msg = array('msg' => 'Error al registrar', 'icono' => 'error');
                }
            } else {
                $data = $this->model->actualizarEstudiante($codigo, $dni, $nombre, $año, $direccion, $telefono, $id);
                if ($data == "modificado") {
                    $msg = array('msg' => 'Estudiante modificado', 'icono' => 'success');
                } else {
                    $msg = array('msg' => 'Error al modificar', 'icono' => 'error');
                }
            }
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function editar($id)
    {
        $data = $this->model->editEstudiante($id);
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function eliminar($id)
    {
        $data = $this->model->estadoEstudiante(0, $id);
        if ($data == 1) {
            $msg = array('msg' => 'Estudiante dado de baja', 'icono' => 'success');
        } else {
            $msg = array('msg' => 'Error al eliminar', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function reingresar($id)
    {
        $data = $this->model->estadoEstudiante(1, $id);
        if ($data == 1) {
            $msg = array('msg' => 'Estudiante restaurado', 'icono' => 'success');
        } else {
            $msg = array('msg' => 'Error al restaurar', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function buscarEstudiante()
    {
        if (isset($_GET['est'])) {
            $valor = $_GET['est'];
            $data = $this->model->buscarEstudiante($valor);
            echo json_encode($data, JSON_UNESCAPED_UNICODE);
            die();
        }
    }
    public function importarExcel()
    {
        if (isset($_FILES['excel'])) {
            $file = $_FILES['excel'];
            $name = $file['name'];
            $tmpName = $file['tmp_name'];
            $extension = pathinfo($name, PATHINFO_EXTENSION);
            
            if ($extension != 'xlsx' && $extension != 'xls') {
                $msg = array('msg' => 'Solo se permiten archivos Excel', 'icono' => 'warning');
            } else {
                require_once 'vendor/autoload.php';
                try {
                    $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($tmpName);
                    $worksheet = $spreadsheet->getActiveSheet();
                    $rows = $worksheet->toArray();
                    // Eliminar la primera fila (encabezados)
                    array_shift($rows);
                    $importados = 0;
                    $errores = 0;
                    $dnis_duplicados = array();
                    $codigos_duplicados = array();
                    
                    foreach ($rows as $row) {
                        if (!empty($row[0])) { // Verificar que la fila no esté vacía
                            $codigo = strClean($row[0]);
                            $dni = strClean($row[1]);
                            $nombre = strClean($row[2]);
                            $año = strClean($row[3]);
                            $direccion = strClean($row[4]);
                            $telefono = strClean($row[5]);
                            
                            if (!empty($codigo) && !empty($dni) && !empty($nombre) && !empty($año)) {
                                $data = $this->model->insertarEstudiante($codigo, $dni, $nombre, $año, $direccion, $telefono);
                                if ($data == "ok") {
                                    $importados++;
                                } else if ($data == "dni_existe") {
                                    if (!in_array($dni, $dnis_duplicados)) {
                                        $dnis_duplicados[] = $dni;
                                        $errores++;
                                    }
                                } else if ($data == "existe") {
                                    if (!in_array($codigo, $codigos_duplicados)) {
                                        $codigos_duplicados[] = $codigo;
                                        $errores++;
                                    }
                                } else {
                                    $errores++;
                                }
                            } else {
                                $errores++;
                            }
                        }
                    }
                    
                    // Construir mensaje simplificado
                    $mensaje = "";
                    if ($importados > 0) {
                        $mensaje .= "✓ Se importaron {$importados} estudiantes correctamente.\n\n";
                    }
                    
                    if ($errores > 0) {
                        $mensaje .= "✗ Se encontraron {$errores} errores:\n";
                        if (!empty($dnis_duplicados)) {
                            $mensaje .= "• DNIs duplicados: " . implode(", ", $dnis_duplicados) . "\n";
                        }
                        if (!empty($codigos_duplicados)) {
                            $mensaje .= "• Códigos duplicados: " . implode(", ", $codigos_duplicados);
                        }
                    }
                    
                    $msg = array(
                        'msg' => $mensaje,
                        'icono' => ($errores == 0) ? 'success' : 'warning'
                    );
                } catch (Exception $e) {
                    $msg = array('msg' => 'Error al procesar el archivo: ' . $e->getMessage(), 'icono' => 'error');
                }
            }
        } else {
            $msg = array('msg' => 'No se ha seleccionado ningún archivo', 'icono' => 'warning');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
    public function eliminarDefinitivo($id)
    {
        $data = $this->model->eliminarDefinitivo($id);
        if ($data == "ok") {
            $msg = array('msg' => 'Estudiante eliminado permanentemente', 'icono' => 'success');
        } else if ($data == "con_prestamos") {
            $msg = array('msg' => 'No se puede borrar porque el estudiante tiene préstamos', 'icono' => 'warning');
        } else {
            $msg = array('msg' => 'Error al eliminar', 'icono' => 'error');
        }
        echo json_encode($msg, JSON_UNESCAPED_UNICODE);
        die();
    }
}
