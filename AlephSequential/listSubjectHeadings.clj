(ns listSubjectHeadings
  (:require [clojure.java.io :as io]
            [clojure.string :as str]))

;; Read a file (filtered) Aleph sequential lines, list the found subject headings and 
;; and writing these to a file with their counts.

(def dir
  ;; The directory where the files are read and written to.
  "/home/tuomo/Melinda-dumppi/reports/")

(def outputfile
  (str dir "loc_report.txt"))

(defn readfile []
  ;; Read the inputfile to a string.
  (slurp (str dir "loc_headings.txt")))

(defn- stringtovect
  [string]
  (-> string
   (str/split #"\n")))

(defn- normalize  [string]
  (str/replace string #"\.$"  ""))

(def data (stringtovect (readfile)))

(defn splitlines
  [vect]
   (map #(str/split % #"\$\$.") vect))

(defn toreport
  [vect]
  (->> vect
       (map rest)
       (flatten)
       (map normalize)
       (frequencies)
       (sort-by last)
       (reverse)))

(def report (toreport (splitlines data)))

(defn report-to-string  [se]
  (apply str
   (map #(str (first %) "\t" (last %) "\n") se)))

(defn writetofile
  [se]
  (spit outputfile (report-to-string se)))
