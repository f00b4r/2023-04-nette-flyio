<?php declare(strict_types = 1);

namespace App\UI\Home;

use App\UI\BasePresenter;
use RuntimeException;
use Tracy\Debugger;
use Tracy\ILogger;

class HomePresenter extends BasePresenter
{

	public function __construct(private readonly string $greetings)
	{
	}

	public function beforeRender(): void
	{
		$this->template->greetings = $this->greetings;
	}

}
