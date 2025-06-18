<?php
class Views{

    public function getView($controlador, $vista, $data="")
    {
        $controlador = get_class($controlador);
        if ($controlador == "Home") {
            $vista = "Views/".$vista.".php";
        }else{
            $vista = "Views/".$controlador."/".$vista.".php";
        }
        
        // Make base_url available in all views
        if (is_array($data)) {
            $data['base_url'] = base_url;
        } else {
            $data = ['base_url' => base_url];
        }
        
        require $vista;
    }
}


?>