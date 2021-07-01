(define (problem task2)
   (:domain secrets)
   (:objects a1 a2 a3 - agent s1 - secret)
   (:init
      (knowSecret a1 s1)
      (connect a1 a2)
      (connect a2 a3)
   )
   (:goal 
      (knowSecret a3 s1)
   )
)
