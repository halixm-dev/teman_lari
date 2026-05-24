# Teman Lari Domain Glossary

## Core Concepts

- **Activity**: A generic logged physical exertion retrieved from Strava. It can be of various types (run, walk, ride, swim, workout).
- **Run**: A specific type of Activity (ActivityType.run). The primary focus of the Teman Lari app.
- **Analyzed Activity**: An Activity that has been processed to determine its specific `WorkoutType` (e.g., easy, tempo, long run, intervals) based on duration, pace, and heart rate relative to the user's thresholds.
- **Running Stats**: The aggregated metrics computed from a user's recent runs, including weekly volume, average pace, training load history, and form score.
- **Training Load (TSS)**: A measure of how hard an activity was, based on heart rate zones and duration. Used to calculate fitness and fatigue.
- **Fitness (CTL)**: Chronic Training Load. A rolling average of training load over the long term (e.g., 42 days), representing aerobic conditioning.
- **Fatigue (ATL)**: Acute Training Load. A rolling average of training load over the short term (e.g., 7 days), representing how tired the body is.
- **Form (TSB)**: Training Stress Balance. The difference between Fitness and Fatigue. Positive values indicate freshness, negative values indicate fatigue.
- **Seam**: The interface between modules where behavior can be altered.
- **Adapter**: A concrete implementation satisfying an interface at a seam.
