create_query_batches <- function(all_queries,
                                 max_queries_per_batch = GEOREFAR_API_MAX_QUERIES_PER_BATCH,
                                 max_sum_of_a_param = GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH,
                                 param_name_for_sum = NULL) {
  if (!is.list(all_queries) || length(all_queries) == 0) {
    return(list())
  }

  batches <- list()
  current_batch_queries <- list()
  current_query_count_in_batch <- 0
  current_sum_val_in_batch <- 0

  for (query_idx in seq_along(all_queries)) {
    query <- all_queries[[query_idx]]

    query_param_val <- 0
    # Calculate the value of the parameter to be summed (e.g., 'max') for the current query
    if (!is.null(param_name_for_sum) && !is.null(query[[param_name_for_sum]])) {
      val <- suppressWarnings(as.numeric(query[[param_name_for_sum]]))
      if (!is.na(val) && val > 0) {
        query_param_val <- val
      }
    }

    # Determine if this query can be added to the current batch
    can_add_to_current_batch <- TRUE

    # Check query count limit
    if ((current_query_count_in_batch + 1) > max_queries_per_batch) {
      can_add_to_current_batch <- FALSE
    }

    # Check sum of parameter limit (if applicable)
    if (can_add_to_current_batch && !is.null(max_sum_of_a_param) && !is.null(param_name_for_sum)) {
      if ((current_sum_val_in_batch + query_param_val) > max_sum_of_a_param && query_param_val > 0) {
        # This check is relevant only if the query itself contributes to the sum (param_value > 0).
        # A query with param_value = 0 (or param not present) doesn't affect the sum limit.
        can_add_to_current_batch <- FALSE
      }
    }

    # If current batch has queries AND this query cannot be added, finalize the current batch
    if (length(current_batch_queries) > 0 && !can_add_to_current_batch) {
      batches <- append(batches, list(current_batch_queries))
      # Reset for new batch
      current_batch_queries <- list()
      current_query_count_in_batch <- 0
      current_sum_val_in_batch <- 0
    }

    # Add query to current batch (which might be new or the existing one)
    current_batch_queries <- append(current_batch_queries, list(query))
    current_query_count_in_batch <- current_query_count_in_batch + 1
    if (!is.null(param_name_for_sum)) { # Only add to sum if param_name_for_sum is defined
      current_sum_val_in_batch <- current_sum_val_in_batch + query_param_val
    }
  }

  # Add the last batch if it contains any queries
  if (length(current_batch_queries) > 0) {
    batches <- append(batches, list(current_batch_queries))
  }

  return(batches)
}
