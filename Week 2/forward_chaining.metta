;; This MeTTa code defines a knowledge base and rule base to evaluate an intern's eligibility  
;; for becoming a staff member. The evaluation is based on several conditions that must 
;; be met, such as completing required courses, attending training, passing an evaluation, 
;; staying with the internship for at least 3 months, and being in the top 5 of Group 1. 
;; The forward chaining mechanism is used to recursively check if the intern satisfies all 
;; the requirements, and based on the result, the intern's eligibility for becoming a staff 
;; member is determined.

;; Knowledge Base:
;; The knowledge base stores facts about the intern, including the number of courses completed, 
;; the number of hours attended, whether they attended the required training, whether they are 
;; in the top 5 of Group 1, whether they passed the evaluation, and the length of their internship.

;; Rule Base:
;; The rule base defines rules for each condition, including:
;; - Completion of at least 5 courses.
;; - Attending at least 40 hours in a month.
;; - Attending training every Saturday.
;; - Being in the top 5 of Group 1.
;; - Staying at least 3 months as an intern.
;; - Passing the evaluation.
;; Finally, a rule combines all these conditions to check if the intern is eligible to become 
;; a staff member.

;; Forward Chaining:
;; Forward chaining is applied to recursively match the conditions from the knowledge base 
;; and rule base. If all conditions are satisfied, the intern is considered eligible to become 
;; a staff member.


;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;!(fromNumber 3)


;; Knowledge base for Intern Eligibility
!(bind! &kb (new-space))

; Add facts to the knowledge base
!(add-atom &kb (completedCourses 5))   ; The intern has completed 5 courses
!(add-atom &kb (attendedHours 40))     ; The intern attended 40 hours in a month
!(add-atom &kb (attendedTraining true)) ; The intern attended training every Saturday
!(add-atom &kb (top5Group1 true))      ; The intern is in the top 5 of Group 1
!(add-atom &kb (internDuration 3))     ; The intern has stayed at least 3 months
!(add-atom &kb (passedEvaluation true)) ; The intern passed the evaluation


;; Rule base for Intern Requirements
!(bind! &rb (new-space))

; Rule to check if an intern has completed the required number of courses
!(add-atom &rb (-> (completedCourses $n) (>= $n 5)))

; Rule to check if the intern attended the required number of hours
!(add-atom &rb (-> (attendedHours $h) (>= $h 40)))

; Rule to check if the intern attended training every Saturday
!(add-atom &rb (-> (attendedTraining true) true))

; Rule to check if the intern is in the top 5 of Group 1
!(add-atom &rb (-> (top5Group1 true) true))

; Rule to check if the intern stayed at least 3 months
!(add-atom &rb (-> (internDuration $d) (>= $d 3)))

; Rule to check if the intern passed the evaluation
!(add-atom &rb (-> (passedEvaluation true) true))

; Rule to check if the intern is eligible to become a staff member
!(add-atom &rb (-> (completedCourses 5) (attendedHours 40) (attendedTraining true) (top5Group1 true) (internDuration 3) (passedEvaluation true) eligible))


;; Forward Chaining Logic
; Base case: if the premise is a fact in the knowledge base, return the premise
(= (fc $premise $depth) $premise)

; Recursive step: apply forward chaining using rules
(= (fc $premise1 (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (match &kb $premise2 (fc $conclusion $k))))

(= (fc $premise2 (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (match &kb $premise1 (fc $conclusion $k))))


;; Test Forward Chaining to Check Eligibility
!(fc eligible (fromNumber 1)) ; Check if the intern is eligible

; Test to see if eligibility result is as expected
!(assertEqualToResult
  (fc eligible (fromNumber 1))
  (eligible))
"