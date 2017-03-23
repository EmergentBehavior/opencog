(use-modules (opencog)
             (opencog nlp)
             (opencog nlp relex2logic)
             (opencog nlp chatbot)
             (opencog openpsi))

(load "translator.scm")
(load "terms.scm")

; Things we have in the AtomSpace
(chat-concept "eat" (list "eat" "ingest" "binge and purge"))
(chat-rule '((lemma "I") (concept "eat") (lemma "meat")) '(say "Do you really? I am a vegan."))

; Input to the system
(define input "I eat meat")

; Parse the input
(define input-sent-node (car (nlp-parse input)))

; Connect the SentenceNode to the anchor
(State (Anchor "CurrentlyProcessing") input-sent-node)

; Get the words
(define input-wl (get-word-list input-sent-node))

; --------------------
; Action selection
; TODO XXX Should be done in OpenPsi

; Find the matching rules using DualLink
(define rules-found (psi-get-dual-match input-wl))

(define rules-satisfied
  (append-map (lambda (r)
    (if (equal? (stv 1 1)
                (cog-evaluate! (car (psi-get-context (gar r)))))
        ; Return the ImplicationLinks
        (list (gar r))
        '()))
    rules-found))

(for-each (lambda (r) (cog-evaluate! (psi-get-action r)))
          rules-satisfied)
