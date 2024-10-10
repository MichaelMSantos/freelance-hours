<?php

namespace App\Livewire\Proposals;

use App\Models\Project;
use App\Models\Proposal;
use Livewire\Attributes\Rule;
use Livewire\Component;

class Create extends Component
{

    public Project $project;

    public bool $modal = false;

    #[Rule(['required', 'email'])]
    public string $email = '';

    #[Rule(['required', 'numeric', 'gt:0'])]
    public int $hours = 0;

    public bool $agree = false;

    public function save()
    {

        $this->validate();
        if (! $this->agree) {
            $this->addError('agree', 'Você precisa concordar com os termos de usos');

            return;
        }

        $proposal = $this->project->proposals()
            ->updateOrCreate(
                ['email' => $this->email],
                ['hours' => $this->hours],

            );

        $this->arrangePositions($proposal);

        $this->dispatch('proposal::created');

        $this->modal = false;
    }

    public function arrangePositions(Proposal $proposal)
    {

        $query = DB::select("
            select *, row_number() over (order by hours asc) as newPosition
            form proposals
            where project_id = :project
            ", ['project' => $proposal->project_id]);

        $position = collect($query)->where('id', '=', $proposal->id)->first();
    }
    public function render()
    {
        return view('livewire.proposals.create');
    }
}
