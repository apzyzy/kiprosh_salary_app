# Set Delayed::Worker.delay_jobs = false to execute all jobs realtime.
Delayed::Worker.delay_jobs = Settings.delayed_jobs.enabled
