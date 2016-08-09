(ns getFunctionTerms
  (:require [clojure.java.io :as io]
            [clojure.string :as str]))

;; Read a file (filtered) Aleph sequential lines, extracting the function codes used
;; and writing these to a file with their counts.

(def dir
  ;; The directory where the files are read and written to.
  "/home/tuomo/Melinda-dumppi/reports/")

(defn readfile []
  ;; Read the inputfile to a string.
  (slurp (str dir "tekijat_ilman.txt")))

(def data (readfile))

(defn stringtovect
  [string]
   (str/split string #"\n"))

(defn normalize [string]
  (str/replace string #"[.)(,:;]" ""))

(defn extractfunctions [vect]
  (map normalize
    (flatten
      (map rest
         (map #(str/split % #"\$\$e") vect)))))

(def functionterms
  (->> (stringtovect (readfile))
       (extractfunctions)
       (frequencies)
       (sort-by last)
       (reverse)))

(defn report-to-string [se]
  (apply str
    (map #(str (first %) "\t" (last %) "\n") se)))

(defn -main []
  (spit (str dir "function_terms.txt")
        (report-to-string functionterms)))

(-main)
