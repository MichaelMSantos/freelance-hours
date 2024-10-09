<?php

namespace App\Livewire\Projects;

use Livewire\Component;

class Create extends Component
{
    public $modal = true;
    public function render()
    {
        return view('livewire.projects.create');
    }
}
