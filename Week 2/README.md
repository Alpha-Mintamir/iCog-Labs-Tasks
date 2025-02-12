# Week 2: Forward and Backward Chaining in MeTTa

This week's task was to implement forward and backward chaining using MeTTa. I applied the logic to iCog-Labs' internship-to-staff conversion process.

## Folder: week 2

### Files:

- `forward_chaining.metta`: Implements forward chaining to determine if an intern meets the requirements to become a staff member.
- `backward_chaining.metta`: Implements backward chaining to verify eligibility by working backward from the goal.

## Logic Overview:

The implementation follows these conditions:

- Completing at least 5 courses.
- Attending at least 40 hours per month.
- Attending weekly Saturday training.
- Being in the top 5 of Group 1.
- Staying a minimum of 3 months as an intern.
- Passing the evaluation.

Forward chaining starts from known facts and applies rules to derive eligibility, while backward chaining works from the goal and verifies required conditions step by step.

This implementation demonstrates automated reasoning in eligibility evaluation using MeTTa.
