import { Character } from '../characters';
import { ValidationError } from '../errorMessage';
import { LifeStage } from '../lifeStage';
import { Validator } from './validator';

export class ChildLaborValidator implements Validator {
  public name: string;
  public errors: ValidationError[];

  constructor () {
    this.name = 'Child Labor Validator';
    this.errors = [];
  }

  public validate (character: Character): boolean {
    const legalChildLabor = character
      .affiliations()
      .filter(a => a.module.legalChildLabor())
      .length > 0;

    this.errors = character.lifeModules().reduce(
      (errors, lifeModule) => {
        if (
          !legalChildLabor &&
          lifeModule.stage === LifeStage.LATE_CHILDHOOD &&
          lifeModule.module.stage === LifeStage.REAL_LIFE
        ) {
          errors.push({
            message: `Module ${lifeModule.module.name} cannot be used for stage ${lifeModule.stage} it is a stage ${lifeModule.module.stage} module`,
            origin: this.name,
          });
        }

        return errors;
      },
      [] as ValidationError[]
    );

    return this.errors.length === 0;
  }
}