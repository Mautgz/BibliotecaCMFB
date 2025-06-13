<?php

class Views{

    public function getView($controlador, $vista, $data="")
    {
        // Ensure $controlador is a string (the controller name)
        $controladorName = is_object($controlador) ? get_class($controlador) : $controlador;

        // error_log("Loading view for controller: " . $controladorName . ", view: " . $vista);

        // Use the controller name string to determine the view path
        // This logic might need adjustment based on how your Views are organized
        // A more robust approach might involve a dedicated routing or view mapping.
        $vistaPath = "Views/".$controladorName."/".$vista.".php";

        // error_log("Attempting to load view from path: " . $vistaPath);

        // If data is provided, extract it so it's available in the view
        if (!empty($data)) {
            extract($data);
        }

        $fullPath = ROOT . $vistaPath; // Use ROOT constant

        if (file_exists($fullPath)) {
             // error_log("View file found, loading: " . $fullPath);
             require_once $fullPath;
        } else {
             error_log("View file not found: " . $fullPath);
             // You might want a more user-friendly error page here
             echo "Error: View file not found: " . $fullPath;
             // Redirect to a generic error page if needed
             // header("Location: " . base_url . "Error/show/404");
             // exit;
        }
    }
} 