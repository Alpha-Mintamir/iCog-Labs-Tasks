;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))


;; Knowledge base (Facts)
!(bind! &kb (new-space))
!(add-atom &kb (completedCourses 5))   ; The intern has completed 5 courses
!(add-atom &kb (attendedHours 40))     ; The intern attended 40 hours in a month
!(add-atom &kb (attendedTraining true)) ; The intern attended training every Saturday
!(add-atom &kb (top5Group1 true))      ; The intern is in the top 5 of Group 1
!(add-atom &kb (internDuration 3))     ; The intern has stayed at least 3 months
!(add-atom &kb (passedEvaluation true)) ; The intern passed the evaluation


;; Rule base (Conditions)
!(bind! &rb (new-space))

;; Conditions for eligibility
(= (course-requirement) (-> (completedCourses $n) (>= $n 5)))
(= (attendance-requirement) (-> (attendedHours $h) (>= $h 40)))
(= (training-requirement) (-> (attendedTraining true) true))
(= (top5-requirement) (-> (top5Group1 true) true))
(= (duration-requirement) (-> (internDuration $d) (>= $d 3)))
(= (evaluation-requirement) (-> (passedEvaluation true) true))

;; Overall eligibility rule
(= (eligibility-rule)
    (-> (completedCourses 5) 
        (attendedHours 40) 
        (attendedTraining true) 
        (top5Group1 true) 
        (internDuration 3) 
        (passedEvaluation true) 
        eligible))

;; Add rules to the rule base
!(add-reduct &rb (course-requirement))
!(add-reduct &rb (attendance-requirement))
!(add-reduct &rb (training-requirement))
!(add-reduct &rb (top5-requirement))
!(add-reduct &rb (duration-requirement))
!(add-reduct &rb (evaluation-requirement))
!(add-reduct &rb (eligibility-rule))


;; Backward chaining function
(: bc (-> Atom Nat Atom))

;; Base case: If the fact exists in the knowledge base, return it
(= (bc $goal $depth)
   (match &kb $goal $goal))

;; Recursive step: Work backwards from the goal, checking rule dependencies
(= (bc $goal (S $k))
   (match &rb (-> $premise1 $premise2 $goal)
          (let* (($premise1 (bc $premise1 $k))
                 ($premise2 (bc $premise2 $k)))
            $goal)))


;; Run backward chaining to check eligibility
!(bc eligible (fromNumber 10))  ;; This should return 'eligible' if all conditions are met
