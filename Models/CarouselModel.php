<?php
class CarouselModel extends Query {
    public function __construct() {
        parent::__construct();
    }

    public function verificarPermisos($id_user, $permiso) {
        $tiene = false;
        $sql = "SELECT p.*, d.* FROM permisos p INNER JOIN detalle_permisos d ON p.id = d.id_permiso WHERE d.id_usuario = $id_user AND p.nombre = '$permiso'";
        $existe = $this->select($sql);
        if ($existe != null || $existe != "") {
            $tiene = true;
        }
        return $tiene;
    }

    public function getCarouselItems() {
        $sql = "SELECT * FROM carousel_items WHERE is_active = 1 ORDER BY order_number ASC";
        return $this->selectAll($sql);
    }

    public function getCarouselItem($id) {
        $sql = "SELECT * FROM carousel_items WHERE id = $id";
        return $this->select($sql);
    }

    public function addCarouselItem($data) {
        $sql = "INSERT INTO carousel_items (title, description, button_text, button_link, image_path, order_number) VALUES (?, ?, ?, ?, ?, ?)";
        $datos = array($data['title'], $data['description'], $data['button_text'], $data['button_link'], $data['image_path'], $data['order_number']);
        return $this->save($sql, $datos);
    }

    public function updateCarouselItem($data, $id) {
        $sql = "UPDATE carousel_items SET title = ?, description = ?, button_text = ?, button_link = ?, image_path = ?, order_number = ? WHERE id = ?";
        $datos = array($data['title'], $data['description'], $data['button_text'], $data['button_link'], $data['image_path'], $data['order_number'], $id);
        return $this->save($sql, $datos);
    }

    public function deleteCarouselItem($id) {
        $sql = "UPDATE carousel_items SET is_active = 0 WHERE id = ?";
        $datos = array($id);
        return $this->save($sql, $datos);
    }

    public function updateOrder($items) {
        foreach ($items as $order => $id) {
            $sql = "UPDATE carousel_items SET order_number = ? WHERE id = ?";
            $datos = array($order, $id);
            $this->save($sql, $datos);
        }
        return true;
    }
} 