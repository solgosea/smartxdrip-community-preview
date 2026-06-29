# Engineering and Safety

Solgo Insight is an early-stage glucose companion project.

It is designed to help users review glucose data, understand patterns, and troubleshoot their data setup more clearly. It is not a medical device, not a dosing tool, and not a replacement for xDrip+, Nightscout, Dexcom, Libre, AAPS, or advice from a healthcare professional.

## Project Scope

Solgo Insight focuses on:

- Reviewing glucose history
- Summarizing high and low episodes
- Showing reports and context around glucose patterns
- Helping users understand whether data sources appear fresh, delayed, stale, or unavailable
- Providing companion views that make existing CGM data easier to read

Solgo Insight does not:

- Control insulin delivery
- Send commands to pumps
- Replace xDrip+ as a CGM collector
- Replace Nightscout as a remote data platform
- Replace Dexcom, Libre, Medtronic, or other official CGM apps
- Provide dosing advice
- Diagnose medical conditions
- Make treatment decisions

## Relationship With xDrip+ and Nightscout

Solgo Insight is built as a companion layer around existing glucose data ecosystems.

xDrip+ and Nightscout already provide important infrastructure for many users, including CGM data collection, local data access, upload, remote sharing, and integration with other tools.

Solgo Insight is intended to sit beside those tools, not replace them.

The goal is to make already-collected data easier to review, explain, and troubleshoot.

## Use of AI-Assisted Development

AI tools are used as part of the development workflow, mainly for:

- UI prototype exploration
- Drafting and improving documentation
- Assisting with automated test coverage
- Reviewing possible edge cases

AI tools are not used as an automatic replacement for engineering decisions.

The product architecture, refactoring direction, core implementation approach, feature design, and safety boundaries are decided and reviewed by a human developer.

Core business logic and feature code are not blindly generated and shipped from AI output. Any AI-assisted output must be reviewed, adjusted, tested, and accepted by the developer before it becomes part of the project.

In short, AI is used as a development assistant, not as the project architect, product owner, or final reviewer.

## Current Engineering Status

Solgo Insight is currently a community preview.

This means:

- The project is still changing quickly
- Some architecture may continue to evolve
- Some features may be incomplete or experimental
- Bugs are expected
- User feedback may significantly change the roadmap

Because of this, users should not rely on Solgo Insight as the only way to monitor glucose data.

Users should continue using their existing CGM app, xDrip+, Nightscout, pump system, AAPS setup, or other trusted tools as appropriate.

## Safety Boundaries

Solgo Insight must follow these boundaries:

- It should describe glucose data, not prescribe treatment.
- It should show observations, not medical conclusions.
- It should avoid implying causation when only correlation is known.
- It should not hide data quality issues.
- It should clearly distinguish fresh, delayed, stale, missing, or unreliable data.
- It should not encourage users to ignore alerts or guidance from their existing diabetes tools.
- It should not be used as the only source for urgent health decisions.

Examples of acceptable language:

- "This pattern appeared often."
- "This event may need review."
- "Nightscout appears delayed compared with local data."
- "This report is for personal review."

Examples of language to avoid:

- "This caused your high."
- "You should take insulin."
- "This is safe."
- "Ignore your existing alert."
- "This confirms a medical condition."

## Data Sources

Solgo Insight may use data from sources such as:

- xDrip+ Local
- Nightscout
- Local app storage
- User-selected context tags
- Future optional integrations

Data source behavior can vary depending on device settings, network conditions, battery optimization, app permissions, sensor behavior, and the user's diabetes setup.

Solgo Insight should show data freshness and quality whenever possible.

## Status Monitor Limitations

The Status Monitor feature is intended to help users troubleshoot their glucose data chain.

It may help answer questions such as:

- Is local data fresh?
- Is Nightscout reachable?
- Is Nightscout delayed compared with local data?
- Is a connected component unavailable?
- Which part of the chain should the user check first?

It cannot guarantee that every problem is detected.

It also cannot fully inspect every CGM device, phone setting, network condition, app permission, or third-party service.

The feature should be treated as a troubleshooting aid, not a complete diagnostic system.

## Reports and Insights

Reports and insights are generated from available glucose data and user context.

They are intended for:

- Personal review
- Pattern awareness
- Discussion with caregivers or healthcare professionals
- Understanding data quality
- Reviewing high and low episodes

They are not intended for:

- Diagnosis
- Insulin dosing
- Treatment changes
- Emergency decisions
- Replacing professional reports from CGM manufacturers or clinicians

Where possible, reports should include:

- Time range
- Data source
- Data coverage
- Unit
- Data quality notes
- Clear disclaimers

## Testing Approach

The project should be tested at multiple levels:

- Unit tests for data parsing and calculation logic
- Integration tests for data source behavior
- UI tests for common user workflows
- Manual testing on real Android devices
- Regression testing for reported bugs
- Comparison against source data where possible

Important areas to test include:

- Unit conversion between mmol/L and mg/dL
- Time window selection
- Data refresh behavior
- Missing or delayed data
- High and low episode detection
- Report calculations
- Status Monitor states
- App upgrade behavior and local data migration

## Known Risks

Current known risk areas include:

- Incorrect assumptions from incomplete glucose data
- Delayed or stale readings being misunderstood as current
- Differences between xDrip+, Nightscout, and other data sources
- User settings not matching expected units or thresholds
- Local data being lost during app reinstall or migration
- UI wording that may imply stronger conclusions than intended
- Experimental features being mistaken for validated medical tools

These risks should be reduced through better UI wording, testing, documentation, and user feedback.

## User Feedback and Issue Handling

Community feedback is important for improving Solgo Insight.

Useful reports include:

- Device model
- Android version
- App version
- Data source used
- Unit setting
- Screenshots if safe to share
- What was expected
- What actually happened
- Whether the issue happens repeatedly

Please remove personal information, tokens, private URLs, and medical identifiers before sharing screenshots or logs.

## Privacy

Solgo Insight should minimize unnecessary data sharing.

The intended privacy direction is:

- Keep personal glucose review data local where possible
- Do not share data automatically
- Let users decide what to export or share
- Avoid exposing Nightscout URLs, tokens, or personal identifiers
- Clearly mark any future feature that sends data outside the device

## Release Philosophy

Solgo Insight is being developed in response to real user feedback.

Early releases may change quickly. Some updates may include large refactors as the architecture evolves.

The project should move toward:

- Clearer release notes
- Smaller and more traceable changes where practical
- Better test coverage
- Better documentation
- More transparent limitations
- Safer wording around health-related insights

## Disclaimer

Solgo Insight is not a medical device and does not provide medical advice.

Do not use Solgo Insight as the only source for glucose monitoring, urgent alerts, insulin dosing, or treatment decisions.

Always rely on your prescribed diabetes management tools, CGM systems, pump systems, healthcare team, and personal safety practices.
