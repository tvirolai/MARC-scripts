(ns soundRecordingsWith027
  (:require [clojure.java.io :as io] [clojure.string :as string]))

; The program reads 1) a list of record ID's and 2) a list of records in Aleph Sequantial format.
; It checks which records are in the ID-list and contain the phrase "Musiikki (esitetty)" the field 336 and
; prints the ID's of these records to the output file.

(def inputFile
  "../dumppi.seq")

(def ids
  "../027_idt.txt")

(defn idSet
  [file]
  (with-open [file (io/reader file)]
    (apply sorted-set 
      (into #{} (line-seq file)))))

(defn isAMatch?
  [id tag line idset]
  (if
    (and (= tag "336") (.contains (clojure.string/lower-case line) "musiikki (esitetty)"))
    (contains? idset id)))

(with-open [rdr (io/reader inputFile)
  out (clojure.java.io/writer "../soundRecordingsWith027.seq" :append true)]
  (let [idset (idSet ids)]
   (doseq [line (line-seq rdr)]
     (let [id (subs line 0 9) 
      tag (subs line 10 13)]
      (if (isAMatch? id tag line idset)
        (do
          (println (str "Found one: " id))
          (.write out (str id "\n")) ))))))