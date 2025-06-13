<?php
class HomeController extends Controller {
    public function __construct() {
        parent::__construct();
    }

    public function index() {
        // This will be the main dashboard or home page
        // We can pass data to the view later if needed
        $data['title'] = 'Página Principal';
        $this->views->getView("Home", "index", $data);
    }
} 