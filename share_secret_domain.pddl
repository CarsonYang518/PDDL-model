(define (domain secrets)
   (:requirements 
      :typing 
      :negative-preconditions 
      :disjunctive-preconditions
      :conditional-effects
   )
   (:types agent secret)

   (:predicates
      ; Agent knows the secret.
      (knowSecret ?agent - agent ?secret - secret)
      ; FromAgent is connected to the toAgent (one way).
      (connect ?fromAgent ?toAgent - agent)
      ; Agent is deceptive.
      (deceptive ?agent - agent)
      ; Agent belives the secret is true.
      (agentTrueBelif ?agent - agent ?secret - secret)
      ; Agent belives the secret is false.
      (agentFalseBelif ?agent - agent ?secret - secret)
   )

   (:action tell
      :parameters (?tellingAgent ?receivingAgent - agent ?secret - secret)
      :precondition (and (knowSecret ?tellingAgent ?secret) (connect ?tellingAgent ?receivingAgent) (not (knowSecret ?receivingAgent ?secret)))
      :effect (knowSecret ?receivingAgent ?secret)
   )

   (:action share_belif
      :parameters (?tellingAgent ?receivingAgent - agent ?secret - secret)
      ; tellingAgent belives the secret is true or false, and tellingAgent is connected to the receivingAgent.
      :precondition (and 
                        (or (agentTrueBelif ?tellingAgent ?secret) (agentFalseBelif ?tellingAgent ?secret))
                        (connect ?tellingAgent ?receivingAgent)
                    )
      :effect (and
                  ; When deceptive tellingAgent belives the secret is true and receivingAgent belives the secret is true,
                  (when (and (deceptive ?tellingAgent) 
                        (agentTrueBelif ?tellingAgent ?secret) 
                        (agentTrueBelif ?receivingAgent ?secret))
                        ; receivingAgent becomes to believe the secret is false instead of true.
                        (and (agentFalseBelif ?receivingAgent ?secret) (not (agentTrueBelif ?receivingAgent ?secret)))
                  )
                  ; When deceptive tellingAgent belives the secret is true and receivingAgent has not belief about the secret,
                  (when (and (deceptive ?tellingAgent) 
                        (agentTrueBelif ?tellingAgent ?secret) 
                        (not (agentTrueBelif ?receivingAgent ?secret)) 
                        (not (agentFalseBelif ?receivingAgent ?secret)))
                        ; receivingAgent becomes to believe the secret is false.
                        (and (agentFalseBelif ?receivingAgent ?secret))
                  )
                  ; When deceptive tellingAgent belives the secret is false and receivingAgent belives the secret is flase,
                  (when (and (deceptive ?tellingAgent) 
                        (agentFalseBelif ?tellingAgent ?secret) 
                        (agentFalseBelif ?receivingAgent ?secret))
                        ; receivingAgent becomes to believe the secret is true instead of false.
                        (and (agentTrueBelif ?receivingAgent ?secret) (not (agentFalseBelif ?receivingAgent ?secret)))
                  )
                  ; When deceptive tellingAgent belives the secret is false and receivingAgent has not belief about the secret,
                  (when (and (deceptive ?tellingAgent) 
                        (agentFalseBelif ?tellingAgent ?secret) 
                        (not (agentTrueBelif ?receivingAgent ?secret)) 
                        (not (agentFalseBelif ?receivingAgent ?secret)))
                        ; receivingAgent becomes to believe the secret is true.
                        (and (agentTrueBelif ?receivingAgent ?secret))
                  )
                  ; When non-deceptive tellingAgent belives the secret is true and receivingAgent belives the secret is flase,
                  (when (and (not (deceptive ?tellingAgent)) 
                        (agentTrueBelif ?tellingAgent ?secret) 
                        (agentFalseBelif ?receivingAgent ?secret))
                        ; receivingAgent becomes to believe the secret is true instead of false.
                        (and (agentTrueBelif ?receivingAgent ?secret) (not (agentFalseBelif ?receivingAgent ?secret)))
                  )
                  ; When non-deceptive tellingAgent belives the secret is true and receivingAgent has not belief about the secret,
                  (when (and (not (deceptive ?tellingAgent)) 
                        (agentTrueBelif ?tellingAgent ?secret) 
                        (not (agentTrueBelif ?receivingAgent ?secret))
                        (not (agentFalseBelif ?receivingAgent ?secret)))
                        ; receivingAgent becomes to believe the secret is true.
                        (and (agentTrueBelif ?receivingAgent ?secret))
                  )
                  ; When non-deceptive tellingAgent belives the secret is false and receivingAgent belives the secret is true,
                  (when (and (not (deceptive ?tellingAgent)) 
                        (agentFalseBelif ?tellingAgent ?secret) 
                        (agentTrueBelif ?receivingAgent ?secret))
                        ; receivingAgent becomes to believe the secret is false instead of true.
                        (and (agentFalseBelif ?receivingAgent ?secret) (not (agentTrueBelif ?receivingAgent ?secret)))
                  )
                  ; When non-deceptive tellingAgent belives the secret is false and receivingAgent has not belief about the secret,
                  (when (and (not (deceptive ?tellingAgent)) 
                        (agentFalseBelif ?tellingAgent ?secret) 
                        (not (agentTrueBelif ?receivingAgent ?secret))
                        (not (agentFalseBelif ?receivingAgent ?secret)))
                        ; receivingAgent becomes to believe the secret is false.
                        (and (agentFalseBelif ?receivingAgent ?secret))
                  )
              )
   )
)
